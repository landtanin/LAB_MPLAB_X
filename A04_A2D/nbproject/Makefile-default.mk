#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/A04_A2D.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/A04_A2D.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=A2D.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/A2D.o
POSSIBLE_DEPFILES=${OBJECTDIR}/A2D.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/A2D.o

# Source Files
SOURCEFILES=A2D.asm


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/A04_A2D.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f887
MP_LINKER_DEBUG_OPTION=-r=ROM@0x1F00:0x1FFE -r=RAM@SHARE:0x70:0x70 -r=RAM@SHARE:0xF0:0xF0 -r=RAM@SHARE:0x170:0x170 -r=RAM@GPR:0x1E5:0x1EF -r=RAM@SHARE:0x1F0:0x1F0
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/A2D.o: A2D.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/A2D.o.d 
	@${RM} ${OBJECTDIR}/A2D.o 
	@${FIXDEPS} dummy.d -e "/Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.ERR" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PICKIT2=1 -q -p$(MP_PROCESSOR_OPTION) -u  $(ASM_OPTIONS)    \\\"/Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.asm\\\" 
	@${MV}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.O ${OBJECTDIR}/A2D.o
	@${MV}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.ERR ${OBJECTDIR}/A2D.o.err
	@${MV}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.LST ${OBJECTDIR}/A2D.o.lst
	@${RM}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.HEX 
	@${DEP_GEN} -d "${OBJECTDIR}/A2D.o"
	@${FIXDEPS} "${OBJECTDIR}/A2D.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/A2D.o: A2D.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/A2D.o.d 
	@${RM} ${OBJECTDIR}/A2D.o 
	@${FIXDEPS} dummy.d -e "/Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.ERR" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  $(ASM_OPTIONS)    \\\"/Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.asm\\\" 
	@${MV}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.O ${OBJECTDIR}/A2D.o
	@${MV}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.ERR ${OBJECTDIR}/A2D.o.err
	@${MV}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.LST ${OBJECTDIR}/A2D.o.lst
	@${RM}  /Users/Mac/Documents/LAB_MPLAB_X/A04_A2D/A2D.HEX 
	@${DEP_GEN} -d "${OBJECTDIR}/A2D.o"
	@${FIXDEPS} "${OBJECTDIR}/A2D.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/A04_A2D.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1 -l"."   -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_PICKIT2=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/A04_A2D.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/A04_A2D.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w  -l"."   -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/A04_A2D.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "${PATH_TO_IDE_BIN}"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
