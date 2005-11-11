# $Id: netfilter.mk 2411 2005-11-11 03:41:43Z nico $

#
# kernel modules
#

IPKG_KMOD_IPT_CONNTRACK-m :=
IPKG_KMOD_IPT_CONNTRACK-$(CONFIG_IP_NF_MATCH_CONNTRACK) += ipt_conntrack
IPKG_KMOD_IPT_CONNTRACK-$(CONFIG_IP_NF_MATCH_HELPER) += ipt_helper
IPKG_KMOD_IPT_CONNTRACK-$(CONFIG_IP_NF_MATCH_CONNMARK) += ipt_connmark
IPKG_KMOD_IPT_CONNTRACK-$(CONFIG_IP_NF_TARGET_CONNMARK) += ipt_CONNMARK
IPKG_KMOD_IPT_CONNTRACK-$(CONFIG_IP_NF_MATCH_STATE) += ipt_state

IPKG_KMOD_IPT_EXTRA-m :=
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_MATCH_LIMIT) += ipt_limit
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_MATCH_MULTIPORT) += multiport
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_MATCH_PKTTYPE) += ipt_pkttype
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent
IPKG_KMOD_IPT_EXTRA-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT

IPKG_KMOD_IPT_FILTER-m :=
IPKG_KMOD_IPT_FILTER-$(CONFIG_IP_NF_MATCH_IPP2P) += ipt_ipp2p
IPKG_KMOD_IPT_FILTER-$(CONFIG_IP_NF_MATCH_LAYER7) += ipt_layer7

IPKG_KMOD_IPT_IPOPT-m :=
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_DSCP) += ipt_dscp
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_TARGET_DSCP) += ipt_DSCP
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_MAC) += ipt_mac
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_MARK) += ipt_mark
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_TARGET_MARK) += ipt_MARK
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_TARGET_TCPMSS) += ipt_TCPMSS
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_TARGET_TTL) += ipt_TTL
IPKG_KMOD_IPT_IPOPT-$(CONFIG_IP_NF_MATCH_UNCLEAN) += ipt_unclean

IPKG_KMOD_IPT_IPSEC-m :=
IPKG_KMOD_IPT_IPSEC-$(CONFIG_IP_NF_MATCH_AH_ESP) += ipt_ah ipt_esp

IPKG_KMOD_IPT_NAT-m :=
IPKG_KMOD_IPT_NAT-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE
IPKG_KMOD_IPT_NAT-$(CONFIG_IP_NF_TARGET_MIRROR) += ipt_MIRROR
IPKG_KMOD_IPT_NAT-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT

IPKG_KMOD_IPT_NAT_EXTRA-m := 
IPKG_KMOD_IPT_NAT_EXTRA-$(CONFIG_IP_NF_AMANDA) += ip_conntrack_amanda
IPKG_KMOD_IPT_NAT_EXTRA-$(CONFIG_IP_NF_CT_PROTO_GRE) += ip_conntrack_proto_gre
IPKG_KMOD_IPT_NAT_EXTRA-$(CONFIG_IP_NF_NAT_PROTO_GRE) += ip_nat_proto_gre
IPKG_KMOD_IPT_NAT_EXTRA-$(CONFIG_IP_NF_PPTP) += ip_conntrack_pptp
IPKG_KMOD_IPT_NAT_EXTRA-$(CONFIG_IP_NF_NAT_PPTP) += ip_nat_pptp
IPKG_KMOD_IPT_NAT_EXTRA-$(CONFIG_IP_NF_NAT_SNMP_BASIC) += ip_nat_snmp_basic
IPKG_KMOD_IPT_NAT_EXTRA-$(CONFIG_IP_NF_TFTP) += ip_conntrack_tftp

IPKG_KMOD_IPT_QUEUE-m :=
IPKG_KMOD_IPT_QUEUE-$(CONFIG_IP_NF_QUEUE) += ip_queue

IPKG_KMOD_IPT_ULOG-m :=
IPKG_KMOD_IPT_ULOG-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG


#
# iptables extensions
#

IPKG_IPTABLES-y := ipt_standard
IPKG_IPTABLES-y := ipt_icmp ipt_tcp ipt_udp

IPKG_IPTABLES_MOD_CONNTRACK-m :=
IPKG_IPTABLES_MOD_CONNTRACK-$(CONFIG_IP_NF_MATCH_CONNMARK) += ipt_connmark
IPKG_IPTABLES_MOD_CONNTRACK-$(CONFIG_IP_NF_TARGET_CONNMARK) += ipt_CONNMARK
IPKG_IPTABLES_MOD_CONNTRACK-$(CONFIG_IP_NF_MATCH_CONNTRACK) += ipt_conntrack
IPKG_IPTABLES_MOD_CONNTRACK-$(CONFIG_IP_NF_MATCH_HELPER) += ipt_helper
IPKG_IPTABLES_MOD_CONNTRACK-$(CONFIG_IP_NF_MATCH_STATE) += ipt_state

IPKG_IPTABLES_MOD_EXTRA-m :=
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_MATCH_LIMIT) += ipt_limit
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_MATCH_MULTIPORT) += ipt_multiport
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_MATCH_PKTTYPE) += ipt_pkttype
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent
IPKG_IPTABLES_MOD_EXTRA-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT

IPKG_IPTABLES_MOD_FILTER-m :=
IPKG_IPTABLES_MOD_FILTER-$(CONFIG_IP_NF_MATCH_IPP2P) += ipt_ipp2p
IPKG_IPTABLES_MOD_FILTER-$(CONFIG_IP_NF_MATCH_LAYER7) += ipt_layer7

IPKG_IPTABLES_MOD_IMQ-m :=
IPKG_IPTABLES_MOD_IMQ-$(CONFIG_IP_NF_TARGET_IMQ) += ipt_IMQ

IPKG_IPTABLES_MOD_IPOPT-m :=
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_DSCP) += ipt_dscp
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_TARGET_DSCP) += ipt_DSCP
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_MAC) += ipt_mac
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_MARK) += ipt_mark
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_TARGET_MARK) += ipt_MARK
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_TARGET_TCPMSS) += ipt_TCPMSS
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_TARGET_TTL) += ipt_TTL
IPKG_IPTABLES_MOD_IPOPT-$(CONFIG_IP_NF_MATCH_UNCLEAN) += ipt_unclean

IPKG_IPTABLES_MOD_IPSEC-m :=
IPKG_IPTABLES_MOD_IPSEC-$(CONFIG_IP_NF_MATCH_AH_ESP) += ipt_ah ipt_esp

IPKG_IPTABLES_MOD_NAT-m :=
IPKG_IPTABLES_MOD_NAT-$(CONFIG_IP_NF_NAT) += ipt_SNAT ipt_DNAT
IPKG_IPTABLES_MOD_NAT-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE
IPKG_IPTABLES_MOD_NAT-$(CONFIG_IP_NF_TARGET_MIRROR) += ipt_MIRROR
IPKG_IPTABLES_MOD_NAT-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT

IPKG_IPTABLES_MOD_ULOG-m :=
IPKG_IPTABLES_MOD_ULOG-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG

IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_CONNTRACK-y)
IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_EXTRA-y)
IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_FILTER-y)
IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_IMQ-y)
IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_IPOPT-y)
IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_IPSEC-y)
IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_NAT-y)
IPKG_IPTABLES-y += $(IPKG_IPTABLES_MOD_ULOG-y)
