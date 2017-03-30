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
VCFG:=
VGEN:=
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
VCFG=	@echo $(EQT)   [CFG]  $<$(EQT)
VGEN=	@echo $(EQT)   [GEN]  $@$(EQT)
VR:=	@
endif

# vim: noet:si:ts=8:sts=8:sw=8
