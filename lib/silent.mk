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
VRM:=
VRMDR:=
VR:=
else
ifeq ($(PSEP),\\)
zimk__pp=$(subst \\,\,$1)
else
zimk__pp=$1
endif
VCC=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[CC]$(ZIMK__PRNORM)   $(call zimk__pp,$@)$(EQT)
VAS=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[AS]$(ZIMK__PRNORM)   $(call zimk__pp,$@)$(EQT)
VCXX=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[CXX]$(ZIMK__PRNORM)  $(call zimk__pp,$@)$(EQT)
VDEP=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[DEP]$(ZIMK__PRNORM)  $(call zimk__pp,$@)$(EQT)
VLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[LD]$(ZIMK__PRNORM)   $(call zimk__pp,$@)$(EQT)
VAR=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLGREEN)[AR]   $(call zimk__pp,$@)$(ZIMK__PRNORM)$(EQT)
VRES=   @echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[RES]$(ZIMK__PRNORM)  $(call zimk__pp,$@)$(EQT)
VCCLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLGREEN)[CCLD]$(ZIMK__PRNORM) $(ZIMK__PRGREEN)$(call zimk__pp,$@)$(ZIMK__PRNORM)$(EQT)
VCXLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLGREEN)[CXLD]$(ZIMK__PRNORM) $(ZIMK__PRGREEN)$(call zimk__pp,$@)$(ZIMK__PRNORM)$(EQT)
VSTRP=  @echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[STRP]$(ZIMK__PRNORM) $(call zimk__pp,$<)$(EQT)
VINST=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLMAGENTA)[INST]$(ZIMK__PRNORM) $(ZIMK__PRMAGENTA)$(call zimk__pp,$(_ZIMK_0))$(ZIMK__PRNORM)$(EQT)
VMD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[MD]$(ZIMK__PRNORM)   $(call zimk__pp,$@)$(EQT)
VCFG=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[CFG]$(ZIMK__PRNORM)  $(call zimk__pp,$<)$(EQT)
VGEN=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[GEN]$(ZIMK__PRNORM)  $(call zimk__pp,$@)$(EQT)
VGIT=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[GIT]$(ZIMK__PRNORM)  $(call zimk__pp,$@)$(EQT)
VSUB=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[SUB]$(ZIMK__PRNORM)  $(call zimk__pp,$@)$(EQT)
VRM=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLRED)[RM]   $(ZIMK__PRNORM)$(ZIMK__PRRED)$(call zimk__pp,$(call zimk__pp,$(_ZIMK_0)))$(ZIMK__PRNORM)$(EQT)
VRMDR=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLRED)[RMDR] $(ZIMK__PRNORM)$(ZIMK__PRLRED)$(call zimk__pp,$(_ZIMK_0))$(ZIMK__PRNORM)$(EQT)
VR:=	@
endif

# vim: noet:si:ts=8:sts=8:sw=8
