V?= 0

ifeq ($(V),1)
VCC:=
VAS:=
VCXX:=
VDEP:=
VLD:=
VAR:=
VRES:=
VCCLD:=
VCXLD:=
VSTRP:=
VINST:=
VMD:=
VCFG:=
VGEN:=
VGIT:=
VSUB:=
VR:=
else
VCC=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRCYAN)[CC]$(ZIMK__PRNORM)   $@$(EQT)
VAS=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRCYAN)[AS]$(ZIMK__PRNORM)   $@$(EQT)
VCXX=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRCYAN)[CXX]$(ZIMK__PRNORM)  $@$(EQT)
VDEP=	@echo $(EQT)   $(ZIMK__PRBOLD)[DEP]$(ZIMK__PRNORM)  $@$(EQT)
VLD=	@echo $(EQT)   $(ZIMK__PRBOLD)[LD]$(ZIMK__PRNORM)   $@$(EQT)
VAR=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRGREEN)[AR]   $@$(ZIMK__PRNORM)$(EQT)
VRES=   @echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRCYAN)[RES]$(ZIMK__PRNORM)  $@$(EQT)
VCCLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRGREEN)[CCLD] $@$(ZIMK__PRNORM)$(EQT)
VCXLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRGREEN)[CXLD] $@$(ZIMK__PRNORM)$(EQT)
VSTRP=  @echo $(EQT)   $(ZIMK__PRBOLD)[STRP]$(ZIMK__PRNORM) $<$(EQT)
VINST=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRMAGENTA)[INST] $(_ZIMK_0)$(ZIMK__PRNORM)$(EQT)
VMD=	@echo $(EQT)   $(ZIMK__PRBOLD)[MD]$(ZIMK__PRNORM)   $@$(EQT)
VCFG=	@echo $(EQT)   $(ZIMK__PRBOLD)[CFG]$(ZIMK__PRNORM)  $<$(EQT)
VGEN=	@echo $(EQT)   $(ZIMK__PRBOLD)[GEN]$(ZIMK__PRNORM)  $@$(EQT)
VGIT=	@echo $(EQT)   $(ZIMK__PRBOLD)[GIT]$(ZIMK__PRNORM)  $@$(EQT)
VSUB=	@echo $(EQT)   $(ZIMK__PRBOLD)[SUB]$(ZIMK__PRNORM)  $@$(EQT)
VR:=	@
endif

# vim: noet:si:ts=8:sts=8:sw=8
