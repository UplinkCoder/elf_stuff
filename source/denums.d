﻿module denums;

import elfutils.elf;

enum ElfClassEnum : ubyte
{
    ELFCLASS32 = .ELFCLASS32,
    ELFCLASS64 = .ELFCLASS64,
    ELFCLASSNONE = .ELFCLASSNONE
}

enum ElfDataEnum : ubyte
{
    ELFDATANONE = .ELFDATANONE, /** Invalid data encoding */
    ELFDATA2LSB = .ELFDATA2LSB, /** 2's complement, little endian */
    ELFDATA2MSB = .ELFDATA2MSB, /*** 2's complement, big endian */
}

enum ElfOsabiEnum : ubyte
{
    ELFOSABI_SYSV = .ELFOSABI_SYSV, /** UNIX System V ABI */
    ELFOSABI_HPUX = .ELFOSABI_HPUX, /*** HP-UX */
    ELFOSABI_NETBSD = .ELFOSABI_NETBSD, /** NetBSD.  */
    ELFOSABI_GNU = .ELFOSABI_GNU, /** Object uses GNU ELF extensions.  */
    ELFOSABI_SOLARIS = .ELFOSABI_SOLARIS, /** Sun Solaris.  */
    ELFOSABI_AIX = .ELFOSABI_AIX, /** IBM AIX.  */
    ELFOSABI_IRIX = .ELFOSABI_IRIX, /** SGI Irix.  */
    ELFOSABI_FREEBSD = .ELFOSABI_FREEBSD, /** FreeBSD.  */
    ELFOSABI_TRU64 = .ELFOSABI_TRU64, /** Compaq TRU64 UNIX.  */
    ELFOSABI_MODESTO = .ELFOSABI_MODESTO, /** Novell Modesto.  */
    ELFOSABI_OPENBSD = .ELFOSABI_OPENBSD, /** OpenBSD.  */
    ELFOSABI_ARM_AEABI = .ELFOSABI_ARM_AEABI, /** ARM EABI */
    ELFOSABI_ARM = .ELFOSABI_ARM, /** ARM */
    ELFOSABI_STANDALONE = .ELFOSABI_STANDALONE /** Standalone (embedded) application */
}


enum ET : ushort
{ 
    ET_NONE = .ET_NONE, /*** No file type */
    ET_REL = .ET_REL, /** Relocatable file */
    ET_EXEC = .ET_EXEC, /** Executable file */
    ET_DYN = .ET_DYN, /** Shared object file */
    ET_CORE = .ET_CORE, /** Core file */
    ET_NUM = .ET_NUM, /** Number of defined types */
    ET_LOOS = .ET_LOOS, /** OS-specific range start */
    ET_HIOS = .ET_HIOS, /** OS-specific range end */
    ET_LOPROC = .ET_LOPROC, /** Processor-specific range start */
    ET_HIPROC = .ET_HIPROC /** Processor-specific range end */
}

enum EM : ushort
{
    EM_NONE = .EM_NONE, /** No machine */
    EM_M32 = .EM_M32, /** AT&T WE 32100 */
    EM_SPARC = .EM_SPARC, /** SUN SPARC */
    EM_386 = .EM_386, /** Intel 80386 */
    EM_68K = .EM_68K, /** Motorola m68k family */
    EM_88K = .EM_88K, /** Motorola m88k family */
    EM_IAMCU = .EM_IAMCU, /** Intel MCU */
    EM_860 = .EM_860, /** Intel 80860 */
    EM_MIPS = .EM_MIPS, /** MIPS R3000 big-endian */
    EM_S370 = .EM_S370, /** IBM System/370 */
    EM_MIPS_RS3_LE = .EM_MIPS_RS3_LE, /** MIPS R3000 little-endian */
    /* reserved 11-14 */
    EM_PARISC = .EM_PARISC, /** HPPA */
    /* reserved 16 */
    EM_VPP500 = .EM_VPP500, /** Fujitsu VPP500 */
    EM_SPARC32PLUS = .EM_SPARC32PLUS, /*** Sun's "v8plus" */
    EM_960 = .EM_960, /*** Intel 80960 */
    EM_PPC = .EM_PPC, /*** PowerPC */
    EM_PPC64 = .EM_PPC64, /*** PowerPC 64-bit */
    EM_S390 = .EM_S390, /** IBM S390 */
    EM_SPU = .EM_SPU, /** IBM SPU/SPC */
    /* reserved 24-35 */
    EM_V800 = .EM_V800, /** NEC V800 series */
    EM_FR20 = .EM_FR20, /** Fujitsu FR20 */
    EM_RH32 = .EM_RH32, /** TRW RH-32 */
    EM_RCE = .EM_RCE, /** Motorola RCE */
    EM_ARM = .EM_ARM, /** ARM */
    EM_FAKE_ALPHA = .EM_FAKE_ALPHA, /** Digital Alpha */
    EM_SH = .EM_SH, /** Hitachi SH */
    EM_SPARCV9 = .EM_SPARCV9, /** SPARC v9 64-bit */
    EM_TRICORE = .EM_TRICORE, /** Siemens Tricore */
    EM_ARC = . EM_ARC, /** Argonaut RISC Core */
    EM_H8_300 = .EM_H8_300, /** Hitachi H8/300 */
    EM_H8_300H = .EM_H8_300H, /** Hitachi H8/300H */
    EM_H8S = .EM_H8S, /** Hitachi H8S */
    EM_H8_500 = .EM_H8_500, /** Hitachi H8/500 */
    EM_IA_64 = .EM_IA_64, /** Intel Merced */
    EM_MIPS_X = .EM_MIPS_X, /** Stanford MIPS-X */
    EM_COLDFIRE = .EM_COLDFIRE, /** Motorola Coldfire */
    EM_68HC12 = .EM_68HC12, /** Motorola M68HC12 */
    EM_MMA = .EM_MMA, /** Fujitsu MMA Multimedia Accelerator */
    EM_PCP = .EM_PCP, /** Siemens PCP */
    EM_NCPU = .EM_NCPU, /** Sony nCPU embeeded RISC */
    EM_NDR1 = .EM_NDR1, /** Denso NDR1 microprocessor */
    EM_STARCORE = .EM_STARCORE, /** Motorola Start*Core processor */
    EM_ME16 = .EM_ME16, /** Toyota ME16 processor */
    EM_ST100 = .EM_ST100, /** STMicroelectronic ST100 processor */
    EM_TINYJ = .EM_TINYJ, /** Advanced Logic Corp. Tinyjemb.fam */
    EM_X86_64 = .EM_X86_64, /** AMD x86-64 architecture */
    EM_PDSP = .EM_PDSP, /** Sony DSP Processor */
    EM_PDP10 = .EM_PDP10, /** Digital PDP-10 */
    EM_PDP11 = .EM_PDP11, /** Digital PDP-11 */
    EM_FX66 = .EM_FX66, /** Siemens FX66 microcontroller */
    EM_ST9PLUS = .EM_ST9PLUS, /** STMicroelectronics ST9+ 8/16 mc */
    EM_ST7 = .EM_ST7, /** STmicroelectronics ST7 8 bit mc */
    EM_68HC16 = .EM_68HC16, /** Motorola MC68HC16 microcontroller */
    EM_68HC11 = .EM_68HC11, /** Motorola MC68HC11 microcontroller */
    EM_68HC08 = .EM_68HC08, /** Motorola MC68HC08 microcontroller */
    EM_68HC05 = .EM_68HC05, /** Motorola MC68HC05 microcontroller */
    EM_SVX = .EM_SVX, /** Silicon Graphics SVx */
    EM_ST19 = .EM_ST19, /** STMicroelectronics ST19 8 bit mc */
    EM_VAX = .EM_VAX, /** Digital VAX */
    EM_CRIS = .EM_CRIS, /** Axis Communications 32-bitemb.proc */
    EM_JAVELIN = .EM_JAVELIN, /** Infineon Technologies 32-bit emb.proc */
    EM_FIREPATH = .EM_FIREPATH, /** Element 14 64-bit DSP Processor */
    EM_ZSP = .EM_ZSP, /** LSI Logic 16-bit DSP Processor */
    EM_MMIX = .EM_MMIX, /** Donald Knuth's educational 64-bit proc */
    EM_HUANY = .EM_HUANY, /** Harvard University machine-independent object files */
    EM_PRISM = .EM_PRISM, /** SiTera Prism */
    EM_AVR = .EM_AVR, /** Atmel AVR 8-bit microcontroller */
    EM_FR30 = .EM_FR30, /** Fujitsu FR30 */
    EM_D10V = .EM_D10V, /** Mitsubishi D10V */
    EM_D30V = .EM_D30V, /** Mitsubishi D30V */
    EM_V850 = .EM_V850, /** NEC v850 */
    EM_M32R = .EM_M32R, /** Mitsubishi M32R */
    EM_MN10300 = .EM_MN10300, /** Matsushita MN10300 */
    EM_MN10200 = .EM_MN10200, /** Matsushita MN10200 */
    EM_PJ = .EM_PJ, /** picoJava */
    EM_OPENRISC = .EM_OPENRISC, /** OpenRISC 32-bitembedded processor */
    EM_ARC_COMPACT = .EM_ARC_COMPACT, /** ARC International ARCompact */
    EM_XTENSA = .EM_XTENSA, /** Tensilica Xtensa Architecture */
    EM_VIDEOCORE = .EM_VIDEOCORE, /** Alphamosaic VideoCore */
    EM_TMM_GPP = .EM_TMM_GPP, /** Thompson Multimedia General Purpose Proc */
    EM_NS32K = .EM_NS32K, /** National Semi. 32000 */
    EM_TPC = .EM_TPC, /** Tenor Network TPC */
    EM_SNP1K = .EM_SNP1K, /** Trebia SNP 1000 */
    EM_ST200 = .EM_ST200, /** STMicroelectronics ST200 */
    EM_IP2K = .EM_IP2K, /** Ubicom IP2xxx */
    EM_MAX = .EM_MAX, /** MAX processor */
    EM_CR = .EM_CR, /** National Semi. CompactRISC */
    EM_F2MC16 = .EM_F2MC16, /** Fujitsu F2MC16 */
    EM_MSP430 = .EM_MSP430, /** Texas Instruments msp430 */
    EM_BLACKFIN = .EM_BLACKFIN, /** Analog Devices Blackfin DSP */
    EM_SE_C33 = .EM_SE_C33, /** Seiko Epson S1C33 family */
    EM_SEP = .EM_SEP, /** Sharp embedded microprocessor */
    EM_ARCA = .EM_ARCA, /** Arca RISC */
    EM_UNICORE = .EM_UNICORE, /** PKU-Unity & MPRC Peking Uni. mc series */
    EM_EXCESS = .EM_EXCESS, /** eXcess configurable cpu */
    EM_DXP = .EM_DXP, /** Icera Semi. Deep Execution Processor */
    EM_ALTERA_NIOS2 = .EM_ALTERA_NIOS2, /** Altera Nios II */
    EM_CRX = .EM_CRX, /** National Semi. CompactRISC CRX */
    EM_XGATE = .EM_XGATE, /** Motorola XGATE */
    EM_C166 = .EM_C166, /** Infineon C16x/XC16x */
    EM_M16C = .EM_M16C, /** Renesas M16C */
    EM_DSPIC30F = .EM_DSPIC30F, /** Microchip Technology dsPIC30F */
    EM_CE = .EM_CE, /** Freescale Communication Engine RISC */
    EM_M32C = .EM_M32C, /** Renesas M32C */
    /* reserved 121-130 */
    EM_TSK3000 = .EM_TSK3000, /** Altium TSK3000 */
    EM_RS08 = .EM_RS08, /** Freescale RS08 */
    EM_SHARC = .EM_SHARC, /** Analog Devices SHARC family */
    EM_ECOG2 = .EM_ECOG2, /** Cyan Technology eCOG2 */
    EM_SCORE7 = .EM_SCORE7, /** Sunplus S+core7 RISC */
    EM_DSP24 = .EM_DSP24, /** New Japan Radio (NJR) 24-bit DSP */
    EM_VIDEOCORE3 = .EM_VIDEOCORE3, /** Broadcom VideoCore III */
    EM_LATTICEMICO32 = .EM_LATTICEMICO32, /** RISC for Lattice FPGA */
    EM_SE_C17 = .EM_SE_C17, /** Seiko Epson C17 */
    EM_TI_C6000 = .EM_TI_C6000, /** Texas Instruments TMS320C6000 DSP */
    EM_TI_C2000 = .EM_TI_C2000, /** Texas Instruments TMS320C2000 DSP */
    EM_TI_C5500 = .EM_TI_C5500, /** Texas Instruments TMS320C55x DSP */
    EM_TI_ARP32 = .EM_TI_ARP32, /** Texas Instruments App. Specific RISC */
    EM_TI_PRU = .EM_TI_PRU, /** Texas Instruments Prog. Realtime Unit */
    /* reserved 145-159 */
    EM_MMDSP_PLUS = .EM_MMDSP_PLUS, /** STMicroelectronics 64bit VLIW DSP */
    EM_CYPRESS_M8C = .EM_CYPRESS_M8C, /** Cypress M8C */
    EM_R32C = .EM_R32C, /** Renesas R32C */
    EM_TRIMEDIA = .EM_TRIMEDIA, /** NXP Semi. TriMedia */
    EM_QDSP6 = .EM_QDSP6, /** QUALCOMM DSP6 */
    EM_8051 = .EM_8051, /** Intel 8051 and variants */
    EM_STXP7X = .EM_STXP7X, /** STMicroelectronics STxP7x */
    EM_NDS32 = .EM_NDS32, /** Andes Tech. compact code emb. RISC */
    EM_ECOG1X = .EM_ECOG1X, /** Cyan Technology eCOG1X */
    EM_MAXQ30 = .EM_MAXQ30, /** Dallas Semi. MAXQ30 mc */
    EM_XIMO16 = .EM_XIMO16, /** New Japan Radio (NJR) 16-bit DSP */
    EM_MANIK = .EM_MANIK, /** M2000 Reconfigurable RISC */
    EM_CRAYNV2 = .EM_CRAYNV2, /** Cray NV2 vector architecture */
    EM_RX = .EM_RX, /** Renesas RX */
    EM_METAG = .EM_METAG, /** Imagination Tech. META */
    EM_MCST_ELBRUS = .EM_MCST_ELBRUS, /** MCST Elbrus */
    EM_ECOG16 = .EM_ECOG16, /** Cyan Technology eCOG16 */
    EM_CR16 = .EM_CR16, /** National Semi. CompactRISC CR16 */
    EM_ETPU = .EM_ETPU, /** Freescale Extended Time Processing Unit */
    EM_SLE9X = .EM_SLE9X, /** Infineon Tech. SLE9X */
    EM_L10M = .EM_L10M, /** Intel L10M */
    EM_K10M = .EM_K10M, /** Intel K10M */
    /* reserved 182 */
    EM_AARCH64 = .EM_AARCH64, /** ARM AARCH64 */
    /* reserved 184 */
    EM_AVR32 = .EM_AVR32, /** Amtel 32-bit microprocessor */
    EM_STM8 = .EM_STM8, /** STMicroelectronics STM8 */
    EM_TILE64 = .EM_TILE64, /** Tileta TILE64 */
    EM_TILEPRO = .EM_TILEPRO, /** Tilera TILEPro */
    EM_MICROBLAZE = .EM_MICROBLAZE, /** Xilinx MicroBlaze */
    EM_CUDA = .EM_CUDA, /** NVIDIA CUDA */
    EM_TILEGX = .EM_TILEGX, /** Tilera TILE-Gx */
    EM_CLOUDSHIELD = .EM_CLOUDSHIELD, /** CloudShield */
    EM_COREA_1ST = .EM_COREA_1ST, /** KIPO-KAIST Core-A 1st gen. */
    EM_COREA_2ND = .EM_COREA_2ND, /** KIPO-KAIST Core-A 2nd gen. */
    EM_ARC_COMPACT2 = .EM_ARC_COMPACT2, /** Synopsys ARCompact V2 */
    EM_OPEN8 = .EM_OPEN8, /** Open8 RISC */
    EM_RL78 = .EM_RL78, /** Renesas RL78 */
    EM_VIDEOCORE5 = .EM_VIDEOCORE5, /** Broadcom VideoCore V */
    EM_78KOR = .EM_78KOR, /** Renesas 78KOR */
    EM_56800EX = .EM_56800EX, /** Freescale 56800EX DSC */
    EM_BA1 = .EM_BA1, /** Beyond BA1 */
    EM_BA2 = .EM_BA2, /** Beyond BA2 */
    EM_XCORE = .EM_XCORE, /** XMOS xCORE */
    EM_MCHP_PIC = .EM_MCHP_PIC, /** Microchip 8-bit PIC(r) */
    /* reserved 205-209 */
    EM_KM32 = .EM_KM32, /** KM211 KM32 */
    EM_KMX32 = .EM_KMX32, /** KM211 KMX32 */
    EM_EMX16 = .EM_EMX16, /** KM211 KMX16 */
    EM_EMX8 = .EM_EMX8, /** KM211 KMX8 */
    EM_KVARC = .EM_KVARC, /** KM211 KVARC */
    EM_CDP = .EM_CDP, /** Paneve CDP */
    EM_COGE = .EM_COGE, /** Cognitive Smart Memory Processor */
    EM_COOL = .EM_COOL, /** Bluechip CoolEngine */
    EM_NORC = .EM_NORC, /** Nanoradio Optimized RISC */
    EM_CSR_KALIMBA = .EM_CSR_KALIMBA, /** CSR Kalimba */
    EM_Z80 = .EM_Z80, /** Zilog Z80 */
    EM_VISIUM = .EM_VISIUM, /** Controls and Data Services VISIUMcore */
    EM_FT32 = .EM_FT32, /** FTDI Chip FT32 */
    EM_MOXIE = .EM_MOXIE, /** Moxie processor */
    EM_AMDGPU = .EM_AMDGPU, /** AMD GPU */
    /* reserved 225-242 */
    EM_RISCV = .EM_RISCV, /** RISC-V */
    
    EM_BPF = .EM_BPF, /** Linux BPF -- in-kernel virtual machine */
    
}


enum PT {
    PT_NULL = .PT_NULL, /** Program header table entry unused */
    PT_LOAD = .PT_LOAD, /** Loadable program segment */
    PT_DYNAMIC = .PT_DYNAMIC, /** Dynamic linking information */
    PT_INTERP = .PT_INTERP, /** Program interpreter */
    PT_NOTE = .PT_NOTE, /** Auxiliary information */
    PT_SHLIB = .PT_SHLIB, /** Reserved */
    PT_PHDR = .PT_PHDR, /** Entry for header table itself */
    PT_TLS = .PT_TLS, /** Thread-local storage segment */
    PT_NUM = .PT_NUM, /** Number of defined types */
    PT_LOOS = .PT_LOOS, /** Start of OS-specific */
    PT_GNU_EH_FRAME = .PT_GNU_EH_FRAME, /** GCC .eh_frame_hdr segment */
    PT_GNU_STACK = .PT_GNU_STACK, /** Indicates stack executability */
    PT_GNU_RELRO = .PT_GNU_RELRO, /** Read-only after relocation */
    PT_SUNWBSS = .PT_SUNWBSS, /** Sun Specific segment */
    PT_SUNWSTACK = .PT_SUNWSTACK, /** Stack segment */
    PT_HIOS = .PT_HIOS, /** End of OS-specific */
    PT_LOPROC = .PT_LOPROC, /** Start of processor-specific */
    PT_HIPROC = .PT_HIPROC, /** End of processor-specific */
}

