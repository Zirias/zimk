ZIMK__DIR :=
ZIMK__PDIRS :=
ZIMK__MK :=
ZIMK__PMKS :=
define __F_ZINC
ZIMK__PDIRS := $$(ZIMK__DIR) $$(ZIMK__PDIRS)
ZIMK__PMKS := $$(ZIMK__MK) $$(ZIMK__PMKS)
ZIMK__DIR := $$(ZIMK__DIR)$$(strip $$(subst /,$$(PSEP),$$(dir $(1))))
ZIMK__MK := $$(ZIMK__DIR)$$(notdir $(1))
include $$(ZIMK__MK)
ZIMK__MK := $$(firstword $$(ZIMK__PMKS))
ZIMK__DIR := $$(firstword $$(ZIMK__PDIRS))
ZIMK__PMKS := $$(wordlist 2, $$(words $$(ZIMK__PMKS)), $$(ZIMK__PMKS))
ZIMK__PDIRS := $$(wordlist 2, $$(words $$(ZIMK__PDIRS)), $$(ZIMK__PDIRS))
endef

define zinc
$(eval $(__F_ZINC))
endef

define __F_BINRULES
_T := $$(strip $(1))
$$(eval $$(BINRULES))
endef

define binrules
$(eval $(__F_BINRULES))
endef

define __F_LIBRULES
_T := $$(strip $(1))
$$(eval $$(LIBRULES))
endef

define librules
$(eval $(__F_LIBRULES))
endef

