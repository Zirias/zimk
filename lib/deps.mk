define BUILDDEPS

_$(_T)_DEPS :=
_$(_T)_DEPS += $$(foreach dep,$$($(_T)_DEPS),$$($$(dep)_LIB))
_$(_T)_DEPS += $$(foreach dep,$$($(_T)_DEPS),$$($$(dep)_EXE))
_$(_T)_DEPS += $$(foreach dep,$$($(_T)_STATICDEPS),$$($$(dep)_STATICLIB))

endef

# vim: noet:si:ts=8:sts=8:sw=8
