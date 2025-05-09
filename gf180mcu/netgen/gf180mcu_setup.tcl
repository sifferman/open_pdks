###
###     Source file gf180mcu_setup.tcl
###     Process this file with the preproc.py processor
###
#---------------------------------------------------------------
# Setup file for netgen LVS
# Global Foundries TECHNAME
#---------------------------------------------------------------
permute default
property default
property parallel none

# Allow override of default #columns in the output format.
catch {format $env(NETGEN_COLUMNS)}

#---------------------------------------------------------------
# For the following, get the cell lists from
# circuit1 and circuit2.
#---------------------------------------------------------------

set cells1 [cells list -all -circuit1]
set cells2 [cells list -all -circuit2]

# NOTE:  In accordance with the LVS manager GUI, the schematic is
# always circuit2, so some items like property "par1" only need to
# be specified for circuit2.

#-------------------------------------------
# Resistors (except metal)
#-------------------------------------------

set devices {}
lappend devices nwell_1p5
lappend devices ppolyf_u
lappend devices npolyf_u
lappend devices ppolyf_s
lappend devices nplus_u
lappend devices pplus_u
lappend devices nw1a_6p0

lappend devices npolyf_s
lappend devices pfield_1p5
lappend devices pf1va_6p0
#ifdef HRPOLY1K
lappend devices ppolyf_u_1k
lappend devices ppolyf_u_1k_6p0
#endif
#ifdef HRPOLY2K
lappend devices ppolyf_u_2k
lappend devices ppolyf_u_2k_6p0
#endif

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	permute "-circuit1 $dev" 1 2
	property "-circuit1 $dev" series enable
	property "-circuit1 $dev" series {r_width critical}
	property "-circuit1 $dev" series {r_length add}
	property "-circuit1 $dev" parallel enable
	property "-circuit1 $dev" parallel {r_length critical}
	property "-circuit1 $dev" parallel {r_width add}
	property "-circuit1 $dev" tolerance {r_length 0.01} {r_width 0.01}
	# Ignore these properties
	property "-circuit1 $dev" delete par1 pm par r
    }
    if {[lsearch $cells2 $dev] >= 0} {
	permute "-circuit2 $dev" 1 2
	property "-circuit2 $dev" series enable
	property "-circuit2 $dev" series {r_width critical}
	property "-circuit2 $dev" series {r_length add}
	property "-circuit2 $dev" parallel enable
	property "-circuit2 $dev" parallel {r_length critical}
	property "-circuit2 $dev" parallel {r_width add}
	property "-circuit2 $dev" tolerance {r_length 0.01} {r_width 0.01}
	# Ignore these properties
	property "-circuit2 $dev" delete par1 pm par r
    }
}

#-------------------------------------------
# RM (metal) resistors
#-------------------------------------------

set devices {}
lappend devices rm1
lappend devices rm2
#ifdef METALS4 || METALS5 || METALS6 || METALS7
lappend devices rm3
#endif (METALS4 || METALS5 || METALS6 || METALS7)
#ifdef METALS5 || METALS6 || METALS7
lappend devices rm4
#endif (METALS5 || METALS6 || METALS7)
#ifdef METALS6 || METALS7
lappend devices rm5
#endif (METALS6 || METALS7)
#ifdef METALS7
lappend devices rm6
#endif (METALS7)
#ifndef THICKMET
lappend devices rmtp
#endif (THICKMET)
#ifdef THICKMET || THICK2MET
lappend devices rmtk
#endif (THICKMET || THICK2MET)

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	permute "-circuit1 $dev" 1 2
	property "-circuit1 $dev" series enable
	property "-circuit1 $dev" series {r_width critical}
	property "-circuit1 $dev" series {r_length add}
	property "-circuit1 $dev" parallel enable
	property "-circuit1 $dev" parallel {r_length critical}
	property "-circuit1 $dev" parallel {r_width add}
	property "-circuit1 $dev" tolerance {r_length 0.01} {r_width 0.01}
	# Ignore these properties
	property "-circuit1 $dev" delete par1 pm par r
    }
    if {[lsearch $cells2 $dev] >= 0} {
	permute "-circuit2 $dev" 1 2
	property "-circuit2 $dev" series enable
	property "-circuit2 $dev" series {r_width critical}
	property "-circuit2 $dev" series {r_length add}
	property "-circuit2 $dev" parallel enable
	property "-circuit2 $dev" parallel {r_length critical}
	property "-circuit2 $dev" parallel {r_width add}
	property "-circuit2 $dev" tolerance {r_length 0.01} {r_width 0.01}
	# Ignore these properties
	property "-circuit2 $dev" delete par1 pm par r
    }
}

#------------------------------------------------------------------
# (MOS) transistors
#------------------------------------------------------------------

set devices {}
lappend devices nfet_03v3
lappend devices pfet_03v3
lappend devices nfet_05v0
lappend devices nfet_06v0
lappend devices pfet_05v0
lappend devices pfet_06v0
lappend devices nfet_06v0_nvt

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	permute "-circuit1 $dev" 1 3
	property "-circuit1 $dev" parallel enable
	property "-circuit1 $dev" parallel {l critical}
	property "-circuit1 $dev" parallel {w add}
	property "-circuit1 $dev" tolerance {w 0.01} {l 0.01}
	# Ignore these properties
	property "-circuit1 $dev" delete par1 NRD NRS par
	property "-circuit1 $dev" delete sa sb sd par dtemp nf
	property "-circuit1 $dev" delete as ad ps pd
    }
    if {[lsearch $cells2 $dev] >= 0} {
	permute "-circuit2 $dev" 1 3
	property "-circuit2 $dev" parallel enable
	property "-circuit2 $dev" parallel {l critical}
	property "-circuit2 $dev" parallel {w add}
	property "-circuit2 $dev" tolerance {w 0.01} {l 0.01}
	# Ignore these properties
	property "-circuit2 $dev" delete par1 NRD NRS par
	property "-circuit2 $dev" delete sa sb sd par dtemp nf
	property "-circuit2 $dev" delete as ad ps pd
    }
}

#------------------------------------------------------------------
# (MOS) salicide block extended source/drain transistors
# (NOTE:  _dss devices are treated as symmetric because the
#  salicide block is present on both sides of the gate.)
#------------------------------------------------------------------

set devices {}
lappend devices nfet_03v3_dss
lappend devices pfet_03v3_dss
lappend devices nfet_06v0_dss
lappend devices pfet_06v0_dss

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	permute "-circuit1 $dev" 1 3
	property "-circuit1 $dev" parallel enable
	property "-circuit1 $dev" parallel {l critical}
	property "-circuit1 $dev" parallel {w add}
	property "-circuit1 $dev" tolerance {w 0.01} {l 0.01}
	# Ignore these properties
	property "-circuit1 $dev" delete par1 NRD NRS par
	property "-circuit1 $dev" delete sa sb sd par dtemp nf
	property "-circuit1 $dev" delete as ad ps pd
	property "-circuit1 $dev" associate {d_sab 1} {s_sab 3}
    }
    if {[lsearch $cells2 $dev] >= 0} {
	permute "-circuit2 $dev" 1 3
	property "-circuit2 $dev" parallel enable
	property "-circuit2 $dev" parallel {l critical}
	property "-circuit2 $dev" parallel {w add}
	property "-circuit2 $dev" tolerance {w 0.01} {l 0.01}
	# Ignore these properties
	property "-circuit2 $dev" delete par1 NRD NRS par
	property "-circuit2 $dev" delete sa sb sd par dtemp nf
	property "-circuit2 $dev" delete as ad ps pd
	property "-circuit2 $dev" associate {d_sab 1} {s_sab 3}
    }
}

#-------------------------------------------
# (MOS) transistors asymmetric source/drain
#-------------------------------------------

set devices {}
lappend devices nfet_10v0_asym
lappend devices pfet_10v0_asym

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	property "-circuit1 $dev" parallel enable
	property "-circuit1 $dev" parallel {l critical}
	property "-circuit1 $dev" parallel {w add}
	property "-circuit1 $dev" tolerance {w 0.01} {l 0.01}
	# Ignore these properties
	property "-circuit1 $dev" delete par1 NRD NRS
	property "-circuit1 $dev" delete sa sb sd par dtemp nf
	property "-circuit1 $dev" delete as ad ps pd
    }
    if {[lsearch $cells2 $dev] >= 0} {
	property "-circuit2 $dev" parallel enable
	property "-circuit2 $dev" parallel {l critical}
	property "-circuit2 $dev" parallel {w add}
	property "-circuit2 $dev" tolerance {w 0.01} {l 0.01}
	# Ignore these properties
	property "-circuit2 $dev" delete par1 NRD NRS
	property "-circuit2 $dev" delete sa sb sd par dtemp nf
	property "-circuit2 $dev" delete as ad ps pd
    }
}

#-------------------------------------------
# MOSCAP capacitors and varactors
#-------------------------------------------

set devices {}
lappend devices cap_nmos_03v3
lappend devices cap_nmos_06v0
lappend devices cap_pmos_03v3
lappend devices cap_pmos_06v0
lappend devices cap_nmos_03v3_b
lappend devices cap_nmos_06v0_b
lappend devices cap_pmos_03v3_b
lappend devices cap_pmos_06v0_b

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	property "-circuit1 $dev" parallel enable
	property "-circuit1 $dev" parallel {c_length critical}
	property "-circuit1 $dev" parallel {c_width add}
	property "-circuit1 $dev" tolerance {c_width 0.01} {c_length 0.01}
	# Ignore these properties
	property "-circuit1 $dev" delete par1 NRD NRS
	property "-circuit1 $dev" delete as ad ps pd
    }
    if {[lsearch $cells2 $dev] >= 0} {
	property "-circuit2 $dev" parallel enable
	property "-circuit2 $dev" parallel {c_length critical}
	property "-circuit2 $dev" parallel {c_width add}
	property "-circuit2 $dev" tolerance {c_width 0.01} {c_length 0.01}
	# Ignore these properties
	property "-circuit2 $dev" delete par1 NRD NRS
	property "-circuit2 $dev" delete as ad ps pd
    }
}

#-------------------------------------------
# diodes
#-------------------------------------------

set devices {}
lappend devices diode_nd2ps_03v3
lappend devices diode_pd2nw_03v3
lappend devices diode_nd2ps_06v0
lappend devices diode_pd2nw_06v0
lappend devices diode_nw2pw_03v3
lappend devices diode_nw2pw_06v0
lappend devices diode_dnw2pw
lappend devices diode_dnw2ps
lappend devices sc_diode

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	property "-circuit1 $dev" parallel enable
	property "-circuit1 $dev" merge {area add_critical}
	property "-circuit1 $dev" tolerance {area 0.02}
	# Ignore these properties
	property "-circuit1 $dev" delete par1 pj
    }
    if {[lsearch $cells2 $dev] >= 0} {
	property "-circuit2 $dev" parallel enable
	property "-circuit2 $dev" merge {area add_critical}
	property "-circuit2 $dev" tolerance {area 0.02}
	# Ignore these properties
	property "-circuit2 $dev" delete par1 pj
    }
}

#-----------------------------------------------
# Fixed-layout devices
# NPN bipolar transistors,
# sandwich (MoM) capacitors, and MiM capacitors
#-----------------------------------------------

set devices {}
lappend devices npn_10p00x10p00
lappend devices npn_05p00x05p00
lappend devices npn_00p54x16p00
lappend devices npn_00p54x08p00
lappend devices npn_00p54x04p00
lappend devices npn_00p54x02p00
lappend devices pnp_10p00x00p42
lappend devices pnp_05p00x00p42
lappend devices pnp_10p00x10p00
lappend devices pnp_05p00x05p00

#ifdef MIM
#ifdef METALS3
lappend devices cap_mim_2f0_m2m3_noshield
#endif (METALS3)
#ifdef METALS4
lappend devices cap_mim_2f0_m3m4_noshield
#endif (METALS4)
#ifdef METALS5
lappend devices cap_mim_2f0_m4m5_noshield
#endif (METALS5)
#ifdef METALS6
lappend devices cap_mim_2f0_m5m6_noshield
#endif (METALS6)
#endif (MIM)

foreach dev $devices {
    if {[lsearch $cells1 $dev] >= 0} {
	property "-circuit1 $dev" parallel enable
	# Ignore these properties
	property "-circuit1 $dev" delete par1
    }
    if {[lsearch $cells2 $dev] >= 0} {
	property "-circuit2 $dev" parallel enable
	# Ignore these properties
	property "-circuit2 $dev" delete par1
    }
}

#---------------------------------------------------------------
# Digital cells (ignore decap, fill, and tap cells)
# Make a separate list for each supported library
#---------------------------------------------------------------
# e.g., ignore class "-circuit2 gf180mcu_fd_sc_7t5v0__endcap"
#---------------------------------------------------------------

foreach cell $cells1 {
#   if {[regexp {gf180mcu_fd_sc_[^_]+__fillcap_[[:digit:]]+} $cell match]} {
#       ignore class "-circuit1 $cell"
#   }
    if {[regexp {gf180mcu_fd_sc_[^_]+__endcap} $cell match]} {
        ignore class "-circuit1 $cell"
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        ignore class "-circuit1 $cell"
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__filltie} $cell match]} {
        ignore class "-circuit1 $cell"
    }
}

foreach cell $cells2 {
#   if {[regexp {gf180mcu_fd_sc_[^_]+__fillcap_[[:digit:]]+} $cell match]} {
#       ignore class "-circuit2 $cell"
#   }
    if {[regexp {gf180mcu_fd_sc_[^_]+__endcap} $cell match]} {
        ignore class "-circuit2 $cell"
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        ignore class "-circuit2 $cell"
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__filltie} $cell match]} {
        ignore class "-circuit2 $cell"
    }
}

# Do the same for the OSU standard cell libraries

foreach cell $cells1 {
    if {[regexp {gf180mcu_osu_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        ignore class "-circuit1 $cell"
    }
}

foreach cell $cells2 {
    if {[regexp {gf180mcu_osu_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        ignore class "-circuit2 $cell"
    }
}

#---------------------------------------------------------------
# Allow the fill, decap, etc., cells to be parallelized
#---------------------------------------------------------------

foreach cell $cells1 {
    if {[regexp {gf180mcu_fd_sc_[^_]+__fillcap_[[:digit:]]+} $cell match]} {
        property "-circuit1 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__endcap} $cell match]} {
        property "-circuit1 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        property "-circuit1 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__filltie} $cell match]} {
        property "-circuit1 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__antenna} $cell match]} {
        property "-circuit1 $cell" parallel enable
    }
}

foreach cell $cells2 {
    if {[regexp {gf180mcu_fd_sc_[^_]+__fillcap_[[:digit:]]+} $cell match]} {
        property "-circuit2 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__endcap} $cell match]} {
        property "-circuit2 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        property "-circuit2 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__filltie} $cell match]} {
        property "-circuit2 $cell" parallel enable
    }
    if {[regexp {gf180mcu_fd_sc_[^_]+__antenna} $cell match]} {
        property "-circuit2 $cell" parallel enable
    }
}

# Do the same for the OSU 3.3V standard cell library

foreach cell $cells1 {
    if {[regexp {gf180mcu_osu_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        property "-circuit1 $cell" parallel enable
    }
}

foreach cell $cells2 {
    if {[regexp {gf180mcu_osu_sc_[^_]+__fill_[[:digit:]]+} $cell match]} {
        property "-circuit2 $cell" parallel enable
    }
}

# Match pins on black-box cells if LVS is called with "-blackbox"
if {[model blackbox]} {
    foreach cell $cells1 {
	if {[model "-circuit1 $cell"] == "blackbox"} {
	    if {[lsearch $cells2 $cell] >= 0} {
		puts stdout "Matching pins of $cell in circuits 1 and 2"
		equate pins "-circuit1 $cell" "-circuit2 $cell"
	    }
	}
    }
}

# Allow parallel reduction of fillcap (decap fill) cells

foreach cell $cells1 {
    if {[regexp {.*gf180mcu_fd_sc_.*__fillcap_[[:digit:]]+} $cell match]} {
	property "-circuit1 $cell" parallel enable
    }
}

foreach cell $cells2 {
    if {[regexp {gf180mcu_fd_sc_.*__fillcap_[[:digit:]]+} $cell match]} {
	property "-circuit2 $cell" parallel enable
    }
}
#---------------------------------------------------------------
