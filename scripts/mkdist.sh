#!/bin/sh

if ! tool="$(type git 2>/dev/null)" || test -z "$tool"; then
	echo >&2 Error: mkdist.sh requires git.
	exit 1
fi

if ! tool="$(type tar 2>/dev/null)" || test -z "$tool"; then
	echo >&2 Error: mkdist.sh requires tar.
	exit 1
fi

if ! reporoot="$(git rev-parse --show-toplevel 2>/dev/null)"; then
	echo >&2 Error: mkdist.sh only works in a git working copy.
	exit 1
fi

version_git=$(git describe)
tag=$(git describe --abbrev=0)

VERSIONPREFIX=${1:-v}
DISTVERSION=${tag#${VERSIONPREFIX}}

if [ "$version" != "$version_git" ]; then
	if ! tool="$(type sed 2>/dev/null)" || test -z "$tool"; then
		echo >&2 Error: mkdist.sh requires sed.
		exit 1
	fi
	if ! tool="$(type date 2>/dev/null)" || test -z "$tool"; then
		echo >&2 Error: mkdist.sh requires date.
		exit 1
	fi
	if [ -z "$(echo $version | sed -ne '/\..*\./p')" ]; then
		DISTVERSION="${DISTVERSION}.0"
	fi
	branch=$(git rev-parse --abbrev-ref HEAD)
	tagbranch=$(git log -1 --format='%D' ${tag} \
		| sed -e 's:.*\(, \([^/]*\)\(, .*\)*\):\2:')
	if [ "$branch" != "$tagbranch" ]; then
		DISTVERSION="${DISTVERSION}.${branch}"
	fi
	DISTVERSION="${DISTVERSION}.$(date +%Y%m%d)"
fi

PKGNAME=${2}
if [ -z "${PKGNAME}" ]; then
	if ! tool="$(type basename 2>/dev/null)" || test -z "$tool"; then
		echo >&2 Error: mkdist.sh requires basename.
		exit 1
	fi
	PKGNAME=$(basename ${reporoot})
fi

DISTNAME="${PKGNAME}-${DISTVERSION}"
cd "$reporoot"
if ! git clone . --recurse-submodules "${DISTNAME}"; then
	rm -fr "${DISTNAME}"
	echo >&2 mkdist.sh: Error cloning "${DISTNAME}"
	exit 1
fi
tar --exclude-vcs -cJf "${DISTNAME}.tar.xz" "${DISTNAME}"
rm -fr "${DISTNAME}"
echo Created distfile: ${reporoot}/${DISTNAME}.tar.xz

