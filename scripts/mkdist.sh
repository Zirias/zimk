#!/bin/sh

if [ -z "${GIT}" ]; then
	echo >&2 Error: mkdist.sh requires git.
	exit 1
fi

if [ -z "${TAR}" ]; then
	echo >&2 Error: mkdist.sh requires tar.
	exit 1
fi

if ! reporoot="$(${GIT} rev-parse --show-toplevel 2>/dev/null)"; then
	echo >&2 Error: mkdist.sh only works in a git working copy.
	exit 1
fi

version_git=$(${GIT} describe)
tag=$(${GIT} describe --abbrev=0)

VERSIONPREFIX=${1:-v}
DISTVERSION=${tag#${VERSIONPREFIX}}

if [ "$tag" != "$version_git" ]; then
	if ! command -v date >/dev/null 2>&1; then
		echo >&2 Error: mkdist.sh requires date.
		exit 1
	fi
	case "${DISTVERSION}" in
		?*.?*.?*) 	;;
		*)		DISTVERSION="${DISTVERSION}.0";;
	esac
	branch=$(${GIT} rev-parse --abbrev-ref HEAD)
	DISTVERSION="${DISTVERSION}.${branch}"
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
if ! ${GIT} clone . --recurse-submodules "${DISTNAME}"; then
	rm -fr "${DISTNAME}"
	echo >&2 mkdist.sh: Error cloning "${DISTNAME}"
	exit 1
fi
[ -n "${NODIST}" ] && for p in ${NODIST}; do
	rm -fr "${DISTNAME}/$p"
done
${TAR} --exclude-vcs --exclude ".github/*" \
	-cJf "${DISTNAME}.tar.xz" "${DISTNAME}"
rm -fr "${DISTNAME}"
echo Created distfile: ${reporoot}/${DISTNAME}.tar.xz

