V?= 0

ifeq ($(V),1)
VCC:=
VAS:=
VDEP:=
VLD:=
VAR:=
VRES:=
VCCLD:=
VSTRP:=
VMD:=
VGEN:=
VGENT:=
VR:=
else
VCC=	@echo $(EQT)   [CC]   $@$(EQT)
VAS=	@echo $(EQT)   [AS]   $@$(EQT)
VDEP=	@echo $(EQT)   [DEP]  $@$(EQT)
VLD=	@echo $(EQT)   [LD]   $@$(EQT)
VAR=	@echo $(EQT)   [AR]   $@$(EQT)
VRES=   @echo $(EQT)   [RES]  $@$(EQT)
VCCLD=	@echo $(EQT)   [CCLD] $@$(EQT)
VSTRP=  @echo $(EQT)   [STRP] $<$(EQT)
VMD=	@echo $(EQT)   [MD]   $@$(EQT)
VGEN=	@echo $(EQT)   [GEN]  $@$(EQT)
VGENT=	@echo $(EQT)   [GEN]  $@: $(VTAGS)$(EQT)
VR:=	@
endif

# vim: noet:si:ts=8:sts=8:sw=8
