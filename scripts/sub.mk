# substitute a list of variables
#
# Usage: $(MAKE) -sf sub.mk SUB_LIST="SUB1=repl1 SUB2=repl2" infile
#
# replaces all occurrances of %%SUB1%% with repl1 and %%SUB2%% with repl2 in
# infile and writes the result to stdout. A %% inside a replacement string
# will be replaced by a space.
#
INFILE=$(firstword $(MAKECMDGOALS))
TEXT=$(file < $(INFILE))
subvars=$(foreach p,$(SUB_LIST),$(firstword $(subst =, ,$p)))
$(foreach p,$(SUB_LIST),$(eval __sub__$(subst %%, ,$p)))
$(foreach p,$(subvars),$(eval TEXT:=$$(subst %%$p%%,$$(__sub__$p),$$(TEXT))))
$(info $(TEXT))
.PHONY: $(INFILE)
$(INFILE): ;@:
