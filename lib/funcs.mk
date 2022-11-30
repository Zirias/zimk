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

toupper = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst \
	  f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst \
	  k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst \
	  p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst \
	  u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst \
	  z,Z,$1))))))))))))))))))))))))))

tolower = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst \
	  F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst \
	  K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst \
	  P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst \
	  U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst \
	  Z,z,$1))))))))))))))))))))))))))

tobool = $(if $(filter-out 0 no false off,$(call tolower,$1)),1,0)

