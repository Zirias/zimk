ZIMK__DIR :=
ZIMK__P0DIR :=
ZIMK__P1DIR :=
ZIMK__P2DIR :=
ZIMK__P3DIR :=
ZIMK__P4DIR :=
ZIMK__P5DIR :=
ZIMK__P6DIR :=
ZIMK__P7DIR :=
ZIMK__P8DIR :=
ZIMK__P9DIR :=
define __F_ZINC
ZIMK__P0DIR := $$(ZIMK__P1DIR)
ZIMK__P1DIR := $$(ZIMK__P2DIR)
ZIMK__P2DIR := $$(ZIMK__P3DIR)
ZIMK__P3DIR := $$(ZIMK__P4DIR)
ZIMK__P4DIR := $$(ZIMK__P5DIR)
ZIMK__P5DIR := $$(ZIMK__P6DIR)
ZIMK__P6DIR := $$(ZIMK__P7DIR)
ZIMK__P7DIR := $$(ZIMK__P8DIR)
ZIMK__P8DIR := $$(ZIMK__P9DIR)
ZIMK__P9DIR := $$(ZIMK__DIR)
ZIMK__DIR := $$(ZIMK__DIR)$$(strip $$(subst /,$$(PSEP),$$(dir $(1))))
include $$(ZIMK__DIR)$$(notdir $(1))
ZIMK__DIR := $$(ZIMK__P9DIR)
ZIMK__P9DIR := $$(ZIMK__P8DIR)
ZIMK__P8DIR := $$(ZIMK__P7DIR)
ZIMK__P7DIR := $$(ZIMK__P6DIR)
ZIMK__P6DIR := $$(ZIMK__P5DIR)
ZIMK__P5DIR := $$(ZIMK__P4DIR)
ZIMK__P4DIR := $$(ZIMK__P3DIR)
ZIMK__P3DIR := $$(ZIMK__P2DIR)
ZIMK__P2DIR := $$(ZIMK__P1DIR)
ZIMK__P1DIR := $$(ZIMK__P0DIR)
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

