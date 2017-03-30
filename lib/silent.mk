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
VCC=	@echo $(EQT)   $(ZIMK__PRCYAN)[CC]$(ZIMK__PRNORM)   $@$(EQT)
VAS=	@echo $(EQT)   $(ZIMK__PRCYAN)[AS]$(ZIMK__PRNORM)   $@$(EQT)
VDEP=	@echo $(EQT)   [DEP]  $@$(EQT)
VLD=	@echo $(EQT)   [LD]   $@$(EQT)
VAR=	@echo $(EQT)   $(ZIMK__PRGREEN)[AR]   $@$(ZIMK__PRNORM)$(EQT)
VRES=   @echo $(EQT)   $(ZIMK__PRCYAN)[RES]$(ZIMK__PRNORM)  $@$(EQT)
VCCLD=	@echo $(EQT)   $(ZIMK__PRGREEN)[CCLD] $@$(ZIMK__PRNORM)$(EQT)
VSTRP=  @echo $(EQT)   [STRP] $<$(EQT)
VMD=	@echo $(EQT)   [MD]   $@$(EQT)
VCFG=	@echo $(EQT)   [CFG]  $<$(EQT)
VGEN=	@echo $(EQT)   [GEN]  $@$(EQT)
VR:=	@
endif

# vim: noet:si:ts=8:sts=8:sw=8
