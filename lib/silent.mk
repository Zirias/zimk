ifeq ($(V),1)
VCC:=
VAS:=
VCXX:=
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
VWRN:=	@echo $(EQT) *** Warning: $(_ZIMK_0)$(EQT)
VR:=
else
MAKEFLAGS+=--no-print-directory
export MAKEFLAGS
ifeq ($(PSEP),\\)
zimk__pp=$(subst \\,\,$1)
else
zimk__pp=$1
endif
VCC=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[CC]$(ZIMK__PRNORM)   $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VAS=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[AS]$(ZIMK__PRNORM)   $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VCXX=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[CXX]$(ZIMK__PRNORM)  $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[LD]$(ZIMK__PRNORM)   $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VAR=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLGREEN)[AR]$(ZIMK__PRNORM)   $(ZIMK__PRGREEN)$(call zimk__pp,$(ZIMK__SUBDIR)$@)$(ZIMK__PRNORM)$(EQT)
VRES=   @echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLCYAN)[RES]$(ZIMK__PRNORM)  $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VCCLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLGREEN)[CCLD]$(ZIMK__PRNORM) $(ZIMK__PRGREEN)$(call zimk__pp,$(ZIMK__SUBDIR)$@)$(ZIMK__PRNORM)$(EQT)
VCXLD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLGREEN)[CXLD]$(ZIMK__PRNORM) $(ZIMK__PRGREEN)$(call zimk__pp,$(ZIMK__SUBDIR)$@)$(ZIMK__PRNORM)$(EQT)
VSTRP=  @echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[STRP]$(ZIMK__PRNORM) $(call zimk__pp,$(ZIMK__SUBDIR)$<)$(EQT)
VINST=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLMAGENTA)[INST]$(ZIMK__PRNORM) $(ZIMK__PRMAGENTA)$(call zimk__pp,$(ZIMK__SUBDIR)$(_ZIMK_0))$(ZIMK__PRNORM)$(EQT)
VMD=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[MD]$(ZIMK__PRNORM)   $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VCFG=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[CFG]$(ZIMK__PRNORM)  $(call zimk__pp,$(ZIMK__SUBDIR)$<)$(EQT)
VGEN=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[GEN]$(ZIMK__PRNORM)  $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VGIT=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[GIT]$(ZIMK__PRNORM)  $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VSUB=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRWHITE)[SUB]$(ZIMK__PRNORM)  $(call zimk__pp,$(ZIMK__SUBDIR)$@)$(EQT)
VRM=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLRED)[RM]   $(ZIMK__PRNORM)$(ZIMK__PRRED)$(call zimk__pp,$(call zimk__pp,$(ZIMK__SUBDIR)$(_ZIMK_0)))$(ZIMK__PRNORM)$(EQT)
VRMDR=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRLRED)[RMDR] $(ZIMK__PRNORM)$(ZIMK__PRLRED)$(call zimk__pp,$(ZIMK__SUBDIR)$(_ZIMK_0))$(ZIMK__PRNORM)$(EQT)
VWRN=	@echo $(EQT)   $(ZIMK__PRBOLD)$(ZIMK__PRYELLOW)[WARN]$(ZIMK__PRNORM) $(ZIMK__PRBOLD)$(ZIMK__PRBROWN)$(_ZIMK_0)$(ZIMK__PRNORM)$(EQT)
VR:=	@
endif

# vim: noet:si:ts=8:sts=8:sw=8
