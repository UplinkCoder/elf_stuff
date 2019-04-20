/* This file defines generic ELF types, structures, and macros.
   Copyright (C) 1999, 2000, 2001, 2002, 2004, 2005, 2007, 2015 Red Hat, Inc.
   This file is part of elfutils.

   This file is free software; you can redistribute it and/or modify
   it under the terms of either

     * the GNU Lesser General Public License as published by the Free
       Software Foundation; either version 3 of the License, or (at
       your option) any later version

   or

     * the GNU General Public License as published by the Free
       Software Foundation; either version 2 of the License, or (at
       your option) any later version

   or both in parallel, as here.

   elfutils is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received copies of the GNU General Public License and
   the GNU Lesser General Public License along with this program.  If
   not, see <http://www.gnu.org/licenses/>.  */

module elfutils.gelf;

import core.stdc.config;

import elfutils.elf;
import elfutils.libelf;

extern (C):

enum _GELF_H = 1;

/* Class independent type definitions.  Correctly speaking this is not
   true.  We assume that 64-bit binaries are the largest class and
   therefore all other classes can be represented without loss.  */

/* Type for a 16-bit quantity.  */
alias GElf_Half = ushort;

/* Types for signed and unsigned 32-bit quantities.  */
alias GElf_Word = uint;
alias GElf_Sword = int;

/* Types for signed and unsigned 64-bit quantities.  */
alias GElf_Xword = c_ulong;
alias GElf_Sxword = c_long;

/* Type of addresses.  */
alias GElf_Addr = c_ulong;

/* Type of file offsets.  */
alias GElf_Off = c_ulong;

/* The ELF file header.  This appears at the start of every ELF file.  */
alias GElf_Ehdr = Elf64_Ehdr;

/* Section header.  */
alias GElf_Shdr = Elf64_Shdr;

/* Section index.  */
/* XXX This should probably be a larger type in preparation of times when
   regular section indices can be larger.  */
alias GElf_Section = ushort;

/* Symbol table entry.  */
alias GElf_Sym = Elf64_Sym;

/* The syminfo section if available contains additional information about
   every dynamic symbol.  */
alias GElf_Syminfo = Elf64_Syminfo;

/* Relocation table entry without addend (in section of type SHT_REL).  */
alias GElf_Rel = Elf64_Rel;

/* Relocation table entry with addend (in section of type SHT_RELA).  */
alias GElf_Rela = Elf64_Rela;

/* Program segment header.  */
alias GElf_Phdr = Elf64_Phdr;

/* Header of a compressed section.  */
alias GElf_Chdr = Elf64_Chdr;

/* Dynamic section entry.  */
alias GElf_Dyn = Elf64_Dyn;

/* Version definition sections.  */
alias GElf_Verdef = Elf64_Verdef;

/* Auxialiary version information.  */
alias GElf_Verdaux = Elf64_Verdaux;

/* Version dependency section.  */
alias GElf_Verneed = Elf64_Verneed;

/* Auxiliary needed version information.  */
alias GElf_Vernaux = Elf64_Vernaux;

/* Type for version symbol information.  */
alias GElf_Versym = ushort;

/* Auxiliary vector.  */
alias GElf_auxv_t = Elf64_auxv_t;

/* Note section contents.  */
alias GElf_Nhdr = Elf64_Nhdr;

/* Move structure.  */
alias GElf_Move = Elf64_Move;

/* Library list structure.  */
alias GElf_Lib = Elf64_Lib;

/* How to extract and insert information held in the st_info field.  */

alias GELF_ST_BIND = ELF64_ST_BIND;
alias GELF_ST_TYPE = ELF64_ST_TYPE;
alias GELF_ST_INFO = ELF64_ST_INFO;

/* How to extract information held in the st_other field.  */

alias GELF_ST_VISIBILITY = ELF64_ST_VISIBILITY;

/* How to extract and insert information held in the r_info field.  */

alias GELF_R_SYM = ELF64_R_SYM;
alias GELF_R_TYPE = ELF64_R_TYPE;
alias GELF_R_INFO = ELF64_R_INFO;

/* How to extract and insert information held in the m_info field.  */
alias GELF_M_SYM = ELF64_M_SYM;
alias GELF_M_SIZE = ELF64_M_SIZE;
alias GELF_M_INFO = ELF64_M_INFO;

/* Get class of the file associated with ELF.  */
int gelf_getclass (Elf* __elf);

/* Return size of array of COUNT elements of the type denoted by TYPE
   in the external representation.  The binary class is taken from ELF.
   The result is based on version VERSION of the ELF standard.  */
size_t gelf_fsize (Elf* __elf, Elf_Type __type, size_t __count, uint __version);

/* Retrieve object file header.  */
GElf_Ehdr* gelf_getehdr (Elf* __elf, GElf_Ehdr* __dest);

/* Update the ELF header.  */
int gelf_update_ehdr (Elf* __elf, GElf_Ehdr* __src);

/* Create new ELF header if none exists.  Creates an Elf32_Ehdr if CLASS
   is ELFCLASS32 or an Elf64_Ehdr if CLASS is ELFCLASS64.  Returns NULL
   on error.  */
void* gelf_newehdr (Elf* __elf, int __class);

/* Get section at OFFSET.  */
Elf_Scn* gelf_offscn (Elf* __elf, GElf_Off __offset);

/* Retrieve section header.  */
GElf_Shdr* gelf_getshdr (Elf_Scn* __scn, GElf_Shdr* __dst);

/* Update section header.  */
int gelf_update_shdr (Elf_Scn* __scn, GElf_Shdr* __src);

/* Retrieve program header table entry.  */
GElf_Phdr* gelf_getphdr (Elf* __elf, int __ndx, GElf_Phdr* __dst);

/* Update the program header.  */
int gelf_update_phdr (Elf* __elf, int __ndx, GElf_Phdr* __src);

/* Create new program header with PHNUM entries.  Creates either an
   Elf32_Phdr or an Elf64_Phdr depending on whether the given ELF is
   ELFCLASS32 or ELFCLASS64.  Returns NULL on error.  */
void* gelf_newphdr (Elf* __elf, size_t __phnum);

/* Get compression header of section if any.  Returns NULL and sets
   elf_errno if the section isn't compressed or an error occurred.  */
GElf_Chdr* gelf_getchdr (Elf_Scn* __scn, GElf_Chdr* __dst);

/* Convert data structure from the representation in the file represented
   by ELF to their memory representation.  */
Elf_Data* gelf_xlatetom (
    Elf* __elf,
    Elf_Data* __dest,
    const(Elf_Data)* __src,
    uint __encode);

/* Convert data structure from to the representation in memory
   represented by ELF file representation.  */
Elf_Data* gelf_xlatetof (
    Elf* __elf,
    Elf_Data* __dest,
    const(Elf_Data)* __src,
    uint __encode);

/* Retrieve REL relocation info at the given index.  */
GElf_Rel* gelf_getrel (Elf_Data* __data, int __ndx, GElf_Rel* __dst);

/* Retrieve RELA relocation info at the given index.  */
GElf_Rela* gelf_getrela (Elf_Data* __data, int __ndx, GElf_Rela* __dst);

/* Update REL relocation information at given index.  */
int gelf_update_rel (Elf_Data* __dst, int __ndx, GElf_Rel* __src);

/* Update RELA relocation information at given index.  */
int gelf_update_rela (Elf_Data* __dst, int __ndx, GElf_Rela* __src);

/* Retrieve symbol information from the symbol table at the given index.  */
GElf_Sym* gelf_getsym (Elf_Data* __data, int __ndx, GElf_Sym* __dst);

/* Update symbol information in the symbol table at the given index.  */
int gelf_update_sym (Elf_Data* __data, int __ndx, GElf_Sym* __src);

/* Retrieve symbol information and separate section index from the
   symbol table at the given index.  */
GElf_Sym* gelf_getsymshndx (
    Elf_Data* __symdata,
    Elf_Data* __shndxdata,
    int __ndx,
    GElf_Sym* __sym,
    Elf32_Word* __xshndx);

/* Update symbol information and separate section index in the symbol
   table at the given index.  */
int gelf_update_symshndx (
    Elf_Data* __symdata,
    Elf_Data* __shndxdata,
    int __ndx,
    GElf_Sym* __sym,
    Elf32_Word __xshndx);

/* Retrieve additional symbol information from the symbol table at the
   given index.  */
GElf_Syminfo* gelf_getsyminfo (
    Elf_Data* __data,
    int __ndx,
    GElf_Syminfo* __dst);

/* Update additional symbol information in the symbol table at the
   given index.  */
int gelf_update_syminfo (Elf_Data* __data, int __ndx, GElf_Syminfo* __src);

/* Get information from dynamic table at the given index.  */
GElf_Dyn* gelf_getdyn (Elf_Data* __data, int __ndx, GElf_Dyn* __dst);

/* Update information in dynamic table at the given index.  */
int gelf_update_dyn (Elf_Data* __dst, int __ndx, GElf_Dyn* __src);

/* Get move structure at the given index.  */
GElf_Move* gelf_getmove (Elf_Data* __data, int __ndx, GElf_Move* __dst);

/* Update move structure at the given index.  */
int gelf_update_move (Elf_Data* __data, int __ndx, GElf_Move* __src);

/* Get library from table at the given index.  */
GElf_Lib* gelf_getlib (Elf_Data* __data, int __ndx, GElf_Lib* __dst);

/* Update library in table at the given index.  */
int gelf_update_lib (Elf_Data* __data, int __ndx, GElf_Lib* __src);

/* Retrieve symbol version information at given index.  */
GElf_Versym* gelf_getversym (Elf_Data* __data, int __ndx, GElf_Versym* __dst);

/* Update symbol version information.  */
int gelf_update_versym (Elf_Data* __data, int __ndx, GElf_Versym* __src);

/* Retrieve required symbol version information at given offset.  */
GElf_Verneed* gelf_getverneed (
    Elf_Data* __data,
    int __offset,
    GElf_Verneed* __dst);

/* Update required symbol version information.  */
int gelf_update_verneed (Elf_Data* __data, int __offset, GElf_Verneed* __src);

/* Retrieve additional required symbol version information at given offset.  */
GElf_Vernaux* gelf_getvernaux (
    Elf_Data* __data,
    int __offset,
    GElf_Vernaux* __dst);

/* Update additional required symbol version information.  */
int gelf_update_vernaux (Elf_Data* __data, int __offset, GElf_Vernaux* __src);

/* Retrieve symbol version definition information at given offset.  */
GElf_Verdef* gelf_getverdef (
    Elf_Data* __data,
    int __offset,
    GElf_Verdef* __dst);

/* Update symbol version definition information.  */
int gelf_update_verdef (Elf_Data* __data, int __offset, GElf_Verdef* __src);

/* Retrieve additional symbol version definition information at given
   offset.  */
GElf_Verdaux* gelf_getverdaux (
    Elf_Data* __data,
    int __offset,
    GElf_Verdaux* __dst);

/* Update additional symbol version definition information.  */
int gelf_update_verdaux (Elf_Data* __data, int __offset, GElf_Verdaux* __src);

/* Get auxv entry at the given index.  */
GElf_auxv_t* gelf_getauxv (Elf_Data* __data, int __ndx, GElf_auxv_t* __dst);

/* Update auxv entry at the given index.  */
int gelf_update_auxv (Elf_Data* __data, int __ndx, GElf_auxv_t* __src);

/* Get note header at the given offset into the data, and the offsets of
   the note's name and descriptor data.  Returns the offset of the next
   note header, or 0 for an invalid offset or corrupt note header.  */
size_t gelf_getnote (
    Elf_Data* __data,
    size_t __offset,
    GElf_Nhdr* __result,
    size_t* __name_offset,
    size_t* __desc_offset);

/* Compute simple checksum from permanent parts of the ELF file.  */
c_long gelf_checksum (Elf* __elf);

/* gelf.h */
