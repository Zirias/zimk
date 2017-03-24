_DIRECTORIES :=

define DIRRULES

_$(_T)_DIRS := $$(sort $$(patsubst %$$(PSEP),%,$$(dir $$(OUTFILES))))

_NEWDIRS := $$(foreach _dir,$$(_$(_T)_DIRS), \
	$$(if $$(findstring $$(_dir),$$(_DIRECTORIES)),,$$(_dir)))

_DIRECTORIES += $$(_NEWDIRS)

$$(_NEWDIRS):
	$$(VMD)
	$$(VR)$$(foreach _dir,$$@,$$(MDP) $$(_dir) $$(CMDSEP))

endef

# vim: noet:si:ts=8:sts=8:sw=8
