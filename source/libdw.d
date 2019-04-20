
/* Interfaces for libdw.
   Copyright (C) 2002-2010, 2013, 2014, 2016, 2018 Red Hat, Inc.
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

module elfutils.libdw;

import elfutils.libelf;

import core.stdc.config;
import core.stdc.stdint;



extern (C):

enum _LIBDW_H = 1;

/* Mode for the session.  */
enum Dwarf_Cmd
{
    DWARF_C_READ = 0, /* Read .. */
    DWARF_C_RDWR = 1, /* Read and write .. */
    DWARF_C_WRITE = 2 /* Write .. */
}

/* Callback results.  */
enum
{
    DWARF_CB_OK = 0,
    DWARF_CB_ABORT = 1
}

/* Error values.  */
enum
{
    DW_TAG_invalid = 0
}

/* Type for offset in DWARF file.  */
alias Dwarf_Off = c_ulong;

/* Type for address in DWARF file.  */
alias Dwarf_Addr = c_ulong;

/* Integer types.  Big enough to hold any numeric value.  */
alias Dwarf_Word = c_ulong;
alias Dwarf_Sword = c_long;
/* For the times we know we do not need that much.  */
alias Dwarf_Half = ushort;

/* DWARF abbreviation record.  */
struct Dwarf_Abbrev;

/* Returned to show the last DIE has be returned.  */

/* Source code line information for CU.  */
struct Dwarf_Lines_s;
alias Dwarf_Lines = Dwarf_Lines_s;

/* One source code line information.  */
struct Dwarf_Line_s;
alias Dwarf_Line = Dwarf_Line_s;

/* Source file information.  */
struct Dwarf_Files_s;
alias Dwarf_Files = Dwarf_Files_s;

/* One address range record.  */
struct Dwarf_Arange_s;
alias Dwarf_Arange = Dwarf_Arange_s;

/* Address ranges of a file.  */
struct Dwarf_Aranges_s;
alias Dwarf_Aranges = Dwarf_Aranges_s;

/* CU representation.  */
struct Dwarf_CU;

/* Macro information.  */
struct Dwarf_Macro_s;
alias Dwarf_Macro = Dwarf_Macro_s;

/* Attribute representation.  */
struct Dwarf_Attribute
{
    uint code;
    uint form;
    ubyte* valp;
    Dwarf_CU* cu;
}

/* Data block representation.  */
struct Dwarf_Block
{
    Dwarf_Word length;
    ubyte* data;
}

/* DIE information.  */
struct Dwarf_Die
{
    /* The offset can be computed from the address.  */
    void* addr;
    Dwarf_CU* cu;
    Dwarf_Abbrev* abbrev;
    // XXX We'll see what other information will be needed.
    c_long padding__;
}

/* Returned to show the last DIE has be returned.  */

/* Global symbol information.  */
struct Dwarf_Global
{
    Dwarf_Off cu_offset;
    Dwarf_Off die_offset;
    const(char)* name;
}

/* One operation in a DWARF location expression.
   A location expression is an array of these.  */
struct Dwarf_Op
{
    ubyte atom; /* Operation */
    Dwarf_Word number; /* Operand */
    Dwarf_Word number2; /* Possible second operand */
    Dwarf_Word offset; /* Offset in location expression */
}

/* This describes one Common Information Entry read from a CFI section.
   Pointers here point into the DATA->d_buf block passed to dwarf_next_cfi.  */
struct Dwarf_CIE
{
    Dwarf_Off CIE_id; /* Always DW_CIE_ID_64 in Dwarf_CIE structures.  */

    /* Instruction stream describing initial state used by FDEs.  If
       we did not understand the whole augmentation string and it did
       not use 'z', then there might be more augmentation data here
       (and in FDEs) before the actual instructions.  */
    const(ubyte)* initial_instructions;
    const(ubyte)* initial_instructions_end;

    Dwarf_Word code_alignment_factor;
    Dwarf_Sword data_alignment_factor;
    Dwarf_Word return_address_register;

    const(char)* augmentation; /* Augmentation string.  */

    /* Augmentation data, might be NULL.  The size is correct only if
       we understood the augmentation string sufficiently.  */
    const(ubyte)* augmentation_data;
    size_t augmentation_data_size;
    size_t fde_augmentation_data_size;
}

/* This describes one Frame Description Entry read from a CFI section.
   Pointers here point into the DATA->d_buf block passed to dwarf_next_cfi.  */
struct Dwarf_FDE
{
    /* Section offset of CIE this FDE refers to.  This will never be
       DW_CIE_ID_64 in an FDE.  If this value is DW_CIE_ID_64, this is
       actually a Dwarf_CIE structure.  */
    Dwarf_Off CIE_pointer;

    /* We can't really decode anything further without looking up the CIE
       and checking its augmentation string.  Here follows the encoded
       initial_location and address_range, then any augmentation data,
       then the instruction stream.  This FDE describes PC locations in
       the byte range [initial_location, initial_location+address_range).
       When the CIE augmentation string uses 'z', the augmentation data is
       a DW_FORM_block (self-sized).  Otherwise, when we understand the
       augmentation string completely, fde_augmentation_data_size gives
       the number of bytes of augmentation data before the instructions.  */
    const(ubyte)* start;
    const(ubyte)* end;
}

/* Each entry in a CFI section is either a CIE described by Dwarf_CIE or
   an FDE described by Dward_FDE.  Check CIE_id to see which you have.  */
union Dwarf_CFI_Entry
{
    Dwarf_Off CIE_id; /* Always DW_CIE_ID_64 in Dwarf_CIE structures.  */
    Dwarf_CIE cie;
    Dwarf_FDE fde;
}

/* Same as DW_CIE_ID_64 from dwarf.h to keep libdw.h independent.  */

/* Opaque type representing a frame state described by CFI.  */
struct Dwarf_Frame_s;
alias Dwarf_Frame = Dwarf_Frame_s;

/* Opaque type representing a CFI section found in a DWARF or ELF file.  */
struct Dwarf_CFI_s;
alias Dwarf_CFI = Dwarf_CFI_s;

/* Handle for debug sessions.  */
struct Dwarf;

/* Out-Of-Memory handler.  */
alias Dwarf_OOM = void function ();

/* Create a handle for a new debug session.  */
Dwarf* dwarf_begin (int fildes, Dwarf_Cmd cmd);

/* Create a handle for a new debug session for an ELF file.  */
Dwarf* dwarf_begin_elf (Elf* elf, Dwarf_Cmd cmd, Elf_Scn* scngrp);

/* Retrieve ELF descriptor used for DWARF access.  */
Elf* dwarf_getelf (Dwarf* dwarf);

/* Retieve DWARF descriptor used for a Dwarf_Die or Dwarf_Attribute.
   A Dwarf_Die or a Dwarf_Attribute is associated with a particular
   Dwarf_CU handle.  This function returns the DWARF descriptor for
   that Dwarf_CU.  */
Dwarf* dwarf_cu_getdwarf (Dwarf_CU* cu);

/* Retrieves the DWARF descriptor for debugaltlink data.  Returns NULL
   if no alternate debug data has been supplied yet.  libdw will try
   to set the alt file on first use of an alt FORM if not yet explicitly
   provided by dwarf_setalt.  */
Dwarf* dwarf_getalt (Dwarf* main);

/* Provides the data referenced by the .gnu_debugaltlink section.  The
   caller should check that MAIN and ALT match (i.e., they have the
   same build ID).  It is the responsibility of the caller to ensure
   that the data referenced by ALT stays valid while it is used by
   MAIN, until dwarf_setalt is called on MAIN with a different
   descriptor, or dwarf_end.  Must be called before inspecting DIEs
   that might have alt FORMs.  Otherwise libdw will try to set the
   alt file itself on first use.  */
void dwarf_setalt (Dwarf* main, Dwarf* alt);

/* Release debugging handling context.  */
int dwarf_end (Dwarf* dwarf);

/* Read the header for the DWARF CU.  */
int dwarf_nextcu (
    Dwarf* dwarf,
    Dwarf_Off off,
    Dwarf_Off* next_off,
    size_t* header_sizep,
    Dwarf_Off* abbrev_offsetp,
    ubyte* address_sizep,
    ubyte* offset_sizep);

/* Read the header of a DWARF CU or type unit.  If TYPE_SIGNATUREP is not
   null, this reads a type unit from the .debug_types section; otherwise
   this reads a CU from the .debug_info section.  */
int dwarf_next_unit (
    Dwarf* dwarf,
    Dwarf_Off off,
    Dwarf_Off* next_off,
    size_t* header_sizep,
    Dwarf_Half* versionp,
    Dwarf_Off* abbrev_offsetp,
    ubyte* address_sizep,
    ubyte* offset_sizep,
    ulong* type_signaturep,
    Dwarf_Off* type_offsetp);

/* Gets the next Dwarf_CU (unit), version, unit type and if available
   the CU DIE and sub (type) DIE of the unit.  Returns 0 on success,
   -1 on error or 1 if there are no more units.  To start iterating
   provide NULL for CU.  If version < 5 the unit type is set from the
   CU DIE if available (DW_UT_compile for DW_TAG_compile_unit,
   DW_UT_type for DW_TAG_type_unit or DW_UT_partial for
   DW_TAG_partial_unit), otherwise it is set to zero.  If unavailable
   (the version or unit type is unknown) the CU DIE is cleared.
   Likewise if the sub DIE isn't isn't available (the unit type is not
   DW_UT_type or DW_UT_split_type) the sub DIE tag is cleared.  */
int dwarf_get_units (
    Dwarf* dwarf,
    Dwarf_CU* cu,
    Dwarf_CU** next_cu,
    Dwarf_Half* version_,
    ubyte* unit_type,
    Dwarf_Die* cudie,
    Dwarf_Die* subdie);

/* Provides information and DIEs associated with the given Dwarf_CU
   unit.  Returns -1 on error, zero on success. Arguments not needed
   may be NULL.  If they are NULL and aren't known yet, they won't be
   looked up.  If the subdie doesn't exist for this unit_type it will
   be cleared.  If there is no unit_id for this unit type it will be
   set to zero.  */
int dwarf_cu_info (
    Dwarf_CU* cu,
    Dwarf_Half* version_,
    ubyte* unit_type,
    Dwarf_Die* cudie,
    Dwarf_Die* subdie,
    ulong* unit_id,
    ubyte* address_size,
    ubyte* offset_size);

/* Decode one DWARF CFI entry (CIE or FDE) from the raw section data.
   The E_IDENT from the originating ELF file indicates the address
   size and byte order used in the CFI section contained in DATA;
   EH_FRAME_P should be true for .eh_frame format and false for
   .debug_frame format.  OFFSET is the byte position in the section
   to start at; on return *NEXT_OFFSET is filled in with the byte
   position immediately after this entry.

   On success, returns 0 and fills in *ENTRY; use dwarf_cfi_cie_p to
   see whether ENTRY->cie or ENTRY->fde is valid.

   On errors, returns -1.  Some format errors will permit safely
   skipping to the next CFI entry though the current one is unusable.
   In that case, *NEXT_OFF will be updated before a -1 return.

   If there are no more CFI entries left in the section,
   returns 1 and sets *NEXT_OFFSET to (Dwarf_Off) -1.  */
int dwarf_next_cfi (
    const(ubyte)* e_ident,
    Elf_Data* data,
    bool eh_frame_p,
    Dwarf_Off offset,
    Dwarf_Off* next_offset,
    Dwarf_CFI_Entry* entry);

/* Use the CFI in the DWARF .debug_frame section.
   Returns NULL if there is no such section (not an error).
   The pointer returned can be used until dwarf_end is called on DWARF,
   and must not be passed to dwarf_cfi_end.
   Calling this more than once returns the same pointer.  */
Dwarf_CFI* dwarf_getcfi (Dwarf* dwarf);

/* Use the CFI in the ELF file's exception-handling data.
   Returns NULL if there is no such data.
   The pointer returned can be used until elf_end is called on ELF,
   and must be passed to dwarf_cfi_end before then.
   Calling this more than once allocates independent data structures.  */
Dwarf_CFI* dwarf_getcfi_elf (Elf* elf);

/* Release resources allocated by dwarf_getcfi_elf.  */
int dwarf_cfi_end (Dwarf_CFI* cache);

/* Return DIE at given offset in .debug_info section.  */
Dwarf_Die* dwarf_offdie (Dwarf* dbg, Dwarf_Off offset, Dwarf_Die* result);

/* Return DIE at given offset in .debug_types section.  */
Dwarf_Die* dwarf_offdie_types (Dwarf* dbg, Dwarf_Off offset, Dwarf_Die* result);

/* Return offset of DIE.  */
Dwarf_Off dwarf_dieoffset (Dwarf_Die* die);

/* Return offset of DIE in CU.  */
Dwarf_Off dwarf_cuoffset (Dwarf_Die* die);

/* Return CU DIE containing given DIE.  */
Dwarf_Die* dwarf_diecu (
    Dwarf_Die* die,
    Dwarf_Die* result,
    ubyte* address_sizep,
    ubyte* offset_sizep);

/* Given a Dwarf_Die addr returns a (reconstructed) Dwarf_Die, or NULL
   if the given addr didn't come from a valid Dwarf_Die.  In particular
   it will make sure that the correct Dwarf_CU pointer is set for the
   Dwarf_Die, the Dwarf_Abbrev pointer will not be set up yet (it will
   only be once the Dwarf_Die is used to read attributes, children or
   siblings).  This functions can be used to keep a reference to a
   Dwarf_Die which you want to refer to later.  The addr, and the result
   of this function, is only valid while the associated Dwarf is valid.  */
Dwarf_Die* dwarf_die_addr_die (Dwarf* dbg, void* addr, Dwarf_Die* result);

/* Return the CU DIE and the header info associated with a Dwarf_Die
   or Dwarf_Attribute.  A Dwarf_Die or a Dwarf_Attribute is associated
   with a particular Dwarf_CU handle.  This function returns the CU or
   type unit DIE and header information for that Dwarf_CU.  The
   returned DIE is either a compile_unit, partial_unit or type_unit.
   If it is a type_unit, then the type signature and type offset are
   also provided, otherwise type_offset will be set to zero.  See also
   dwarf_diecu and dwarf_next_unit.  */
Dwarf_Die* dwarf_cu_die (
    Dwarf_CU* cu,
    Dwarf_Die* result,
    Dwarf_Half* versionp,
    Dwarf_Off* abbrev_offsetp,
    ubyte* address_sizep,
    ubyte* offset_sizep,
    ulong* type_signaturep,
    Dwarf_Off* type_offsetp);

/* Return CU DIE containing given address.  */
Dwarf_Die* dwarf_addrdie (Dwarf* dbg, Dwarf_Addr addr, Dwarf_Die* result);

/* Return child of current DIE.  */
int dwarf_child (Dwarf_Die* die, Dwarf_Die* result);

/* Locates the first sibling of DIE and places it in RESULT.
   Returns 0 if a sibling was found, -1 if something went wrong.
   Returns 1 if no sibling could be found and, if RESULT is not
   the same as DIE, it sets RESULT->addr to the address of the
   (non-sibling) DIE that follows this one, or NULL if this DIE
   was the last one in the compilation unit.  */
int dwarf_siblingof (Dwarf_Die* die, Dwarf_Die* result);

/* For type aliases and qualifier type DIEs, which don't modify or
   change the structural layout of the underlying type, follow the
   DW_AT_type attribute (recursively) and return the underlying type
   Dwarf_Die.

   Returns 0 when RESULT contains a Dwarf_Die (possibly equal to the
   given DIE) that isn't a type alias or qualifier type.  Returns 1
   when RESULT contains a type alias or qualifier Dwarf_Die that
   couldn't be peeled further (it doesn't have a DW_TAG_type
   attribute).  Returns -1 when an error occured.

   The current DWARF specification defines one type alias tag
   (DW_TAG_typedef) and seven modifier/qualifier type tags
   (DW_TAG_const_type, DW_TAG_volatile_type, DW_TAG_restrict_type,
   DW_TAG_atomic_type, DW_TAG_immutable_type, DW_TAG_packed_type and
   DW_TAG_shared_type).  This function won't peel modifier type
   tags that change the way the underlying type is accessed such
   as the pointer or reference type tags (DW_TAG_pointer_type,
   DW_TAG_reference_type or DW_TAG_rvalue_reference_type).

   A future version of this function might peel other alias or
   qualifier type tags if a future DWARF version or GNU extension
   defines other type aliases or qualifier type tags that don't modify,
   change the structural layout or the way to access the underlying type.  */
int dwarf_peel_type (Dwarf_Die* die, Dwarf_Die* result);

/* Check whether the DIE has children.  */
int dwarf_haschildren (Dwarf_Die* die);

/* Walks the attributes of DIE, starting at the one OFFSET bytes in,
   calling the CALLBACK function for each one.  Stops if the callback
   function ever returns a value other than DWARF_CB_OK and returns the
   offset of the offending attribute.  If the end of the attributes
   is reached 1 is returned.  If something goes wrong -1 is returned and
   the dwarf error number is set.  */
ptrdiff_t dwarf_getattrs (
    Dwarf_Die* die,
    int function (Dwarf_Attribute*, void*) callback,
    void* arg,
    ptrdiff_t offset);

/* Return tag of given DIE.  */
int dwarf_tag (Dwarf_Die* die);

/* Return specific attribute of DIE.  */
Dwarf_Attribute* dwarf_attr (
    Dwarf_Die* die,
    uint search_name,
    Dwarf_Attribute* result);

/* Check whether given DIE has specific attribute.  */
int dwarf_hasattr (Dwarf_Die* die, uint search_name);

/* These are the same as dwarf_attr and dwarf_hasattr, respectively,
   but they resolve an indirect attribute through DW_AT_abstract_origin.  */
Dwarf_Attribute* dwarf_attr_integrate (
    Dwarf_Die* die,
    uint search_name,
    Dwarf_Attribute* result);
int dwarf_hasattr_integrate (Dwarf_Die* die, uint search_name);

/* Check whether given attribute has specific form.  */
int dwarf_hasform (Dwarf_Attribute* attr, uint search_form);

/* Return attribute code of given attribute.  */
uint dwarf_whatattr (Dwarf_Attribute* attr);

/* Return form code of given attribute.  */
uint dwarf_whatform (Dwarf_Attribute* attr);

/* Return string associated with given attribute.  */
const(char)* dwarf_formstring (Dwarf_Attribute* attrp);

/* Return unsigned constant represented by attribute.  */
int dwarf_formudata (Dwarf_Attribute* attr, Dwarf_Word* return_uval);

/* Return signed constant represented by attribute.  */
int dwarf_formsdata (Dwarf_Attribute* attr, Dwarf_Sword* return_uval);

/* Return address represented by attribute.  */
int dwarf_formaddr (Dwarf_Attribute* attr, Dwarf_Addr* return_addr);

/* This function is deprecated.  Always use dwarf_formref_die instead.
   Return reference offset represented by attribute.  */
int dwarf_formref (Dwarf_Attribute* attr, Dwarf_Off* return_offset);

/* Look up the DIE in a reference-form attribute.  */
Dwarf_Die* dwarf_formref_die (Dwarf_Attribute* attr, Dwarf_Die* die_mem);

/* Return block represented by attribute.  */
int dwarf_formblock (Dwarf_Attribute* attr, Dwarf_Block* return_block);

/* Return flag represented by attribute.  */
int dwarf_formflag (Dwarf_Attribute* attr, bool* return_bool);

/* Simplified attribute value access functions.  */

/* Return string in name attribute of DIE.  */
const(char)* dwarf_diename (Dwarf_Die* die);

/* Return high PC attribute of DIE.  */
int dwarf_highpc (Dwarf_Die* die, Dwarf_Addr* return_addr);

/* Return low PC attribute of DIE.  */
int dwarf_lowpc (Dwarf_Die* die, Dwarf_Addr* return_addr);

/* Return entry_pc or low_pc attribute of DIE.  */
int dwarf_entrypc (Dwarf_Die* die, Dwarf_Addr* return_addr);

/* Return 1 if DIE's lowpc/highpc or ranges attributes match the PC address,
   0 if not, or -1 for errors.  */
int dwarf_haspc (Dwarf_Die* die, Dwarf_Addr pc);

/* Enumerate the PC address ranges covered by this DIE, covering all
   addresses where dwarf_haspc returns true.  In the first call OFFSET
   should be zero and *BASEP need not be initialized.  Returns -1 for
   errors, zero when there are no more address ranges to report, or a
   nonzero OFFSET value to pass to the next call.  Each subsequent call
   must preserve *BASEP from the prior call.  Successful calls fill in
   *STARTP and *ENDP with a contiguous address range.  */
ptrdiff_t dwarf_ranges (
    Dwarf_Die* die,
    ptrdiff_t offset,
    Dwarf_Addr* basep,
    Dwarf_Addr* startp,
    Dwarf_Addr* endp);

/* Return byte size attribute of DIE.  */
int dwarf_bytesize (Dwarf_Die* die);

/* Return bit size attribute of DIE.  */
int dwarf_bitsize (Dwarf_Die* die);

/* Return bit offset attribute of DIE.  */
int dwarf_bitoffset (Dwarf_Die* die);

/* Return array order attribute of DIE.  */
int dwarf_arrayorder (Dwarf_Die* die);

/* Return source language attribute of DIE.  */
int dwarf_srclang (Dwarf_Die* die);

/* Get abbreviation at given offset for given DIE.  */
Dwarf_Abbrev* dwarf_getabbrev (
    Dwarf_Die* die,
    Dwarf_Off offset,
    size_t* lengthp);

/* Get abbreviation at given offset in .debug_abbrev section.  */
int dwarf_offabbrev (
    Dwarf* dbg,
    Dwarf_Off offset,
    size_t* lengthp,
    Dwarf_Abbrev* abbrevp);

/* Get abbreviation code.  */
uint dwarf_getabbrevcode (Dwarf_Abbrev* abbrev);

/* Get abbreviation tag.  */
uint dwarf_getabbrevtag (Dwarf_Abbrev* abbrev);

/* Return true if abbreviation is children flag set.  */
int dwarf_abbrevhaschildren (Dwarf_Abbrev* abbrev);

/* Get number of attributes of abbreviation.  */
int dwarf_getattrcnt (Dwarf_Abbrev* abbrev, size_t* attrcntp);

/* Get specific attribute of abbreviation.  */
int dwarf_getabbrevattr (
    Dwarf_Abbrev* abbrev,
    size_t idx,
    uint* namep,
    uint* formp,
    Dwarf_Off* offset);

/* Get specific attribute of abbreviation and any data encoded with it.
   Specifically for DW_FORM_implicit_const data will be set to the
   constant value associated.  */
int dwarf_getabbrevattr_data (
    Dwarf_Abbrev* abbrev,
    size_t idx,
    uint* namep,
    uint* formp,
    Dwarf_Sword* datap,
    Dwarf_Off* offset);

/* Get string from-debug_str section.  */
const(char)* dwarf_getstring (Dwarf* dbg, Dwarf_Off offset, size_t* lenp);

/* Get public symbol information.  */
ptrdiff_t dwarf_getpubnames (
    Dwarf* dbg,
    int function (Dwarf*, Dwarf_Global*, void*) callback,
    void* arg,
    ptrdiff_t offset);

/* Get source file information for CU.  */
int dwarf_getsrclines (Dwarf_Die* cudie, Dwarf_Lines** lines, size_t* nlines);

/* Return one of the source lines of the CU.  */
Dwarf_Line* dwarf_onesrcline (Dwarf_Lines* lines, size_t idx);

/* Get the file source files used in the CU.  */
int dwarf_getsrcfiles (Dwarf_Die* cudie, Dwarf_Files** files, size_t* nfiles);

/* Get source for address in CU.  */
Dwarf_Line* dwarf_getsrc_die (Dwarf_Die* cudie, Dwarf_Addr addr);

/* Get source for file and line number.  */
int dwarf_getsrc_file (
    Dwarf* dbg,
    const(char)* fname,
    int line,
    int col,
    Dwarf_Line*** srcsp,
    size_t* nsrcs);

/* Return line address.  */
int dwarf_lineaddr (Dwarf_Line* line, Dwarf_Addr* addrp);

/* Return line VLIW operation index.  */
int dwarf_lineop_index (Dwarf_Line* line, uint* op_indexp);

/* Return line number.  */
int dwarf_lineno (Dwarf_Line* line, int* linep);

/* Return column in line.  */
int dwarf_linecol (Dwarf_Line* line, int* colp);

/* Return true if record is for beginning of a statement.  */
int dwarf_linebeginstatement (Dwarf_Line* line, bool* flagp);

/* Return true if record is for end of sequence.  */
int dwarf_lineendsequence (Dwarf_Line* line, bool* flagp);

/* Return true if record is for beginning of a basic block.  */
int dwarf_lineblock (Dwarf_Line* line, bool* flagp);

/* Return true if record is for end of prologue.  */
int dwarf_lineprologueend (Dwarf_Line* line, bool* flagp);

/* Return true if record is for beginning of epilogue.  */
int dwarf_lineepiloguebegin (Dwarf_Line* line, bool* flagp);

/* Return instruction-set architecture in this record.  */
int dwarf_lineisa (Dwarf_Line* line, uint* isap);

/* Return code path discriminator in this record.  */
int dwarf_linediscriminator (Dwarf_Line* line, uint* discp);

/* Find line information for address.  The returned string is NULL when
   an error occured, or the file path.  The file path is either absolute
   or relative to the compilation directory.  See dwarf_decl_file.  */
const(char)* dwarf_linesrc (
    Dwarf_Line* line,
    Dwarf_Word* mtime,
    Dwarf_Word* length);

/* Return file information.  The returned string is NULL when
   an error occured, or the file path.  The file path is either absolute
   or relative to the compilation directory.  See dwarf_decl_file.  */
const(char)* dwarf_filesrc (
    Dwarf_Files* file,
    size_t idx,
    Dwarf_Word* mtime,
    Dwarf_Word* length);

/* Return the Dwarf_Files and index associated with the given Dwarf_Line.  */
int dwarf_line_file (Dwarf_Line* line, Dwarf_Files** files, size_t* idx);

/* Return the directory list used in the file information extracted.
   (*RESULT)[0] is the CU's DW_AT_comp_dir value, and may be null.
   (*RESULT)[0..*NDIRS-1] are the compile-time include directory path
   encoded by the compiler.  */
int dwarf_getsrcdirs (Dwarf_Files* files, const(char**)* result, size_t* ndirs);

/* Iterates through the debug line units.  Returns 0 on success, -1 on
   error or 1 if there are no more units.  To start iterating use zero
   for OFF and set *CU to NULL.  On success NEXT_OFF will be set to
   the next offset to use.  The *CU will be set if this line table
   needed a specific CU and needs to be given when calling
   dwarf_next_lines again (to help dwarf_next_lines quickly find the
   next CU).  *CU might be set to NULL when it couldn't be found (the
   compilation directory entry will be the empty string in that case)
   or for DWARF 5 or later tables, which are self contained.  SRCFILES
   and SRCLINES may be NULL if the caller is not interested in the
   actual line or file table.  On success and when not NULL, NFILES
   and NLINES will be set to the number of files in the file table and
   number of lines in the line table.  */
int dwarf_next_lines (
    Dwarf* dwarf,
    Dwarf_Off off,
    Dwarf_Off* next_off,
    Dwarf_CU** cu,
    Dwarf_Files** srcfiles,
    size_t* nfiles,
    Dwarf_Lines** srclines,
    size_t* nlines);

/* Return location expression, decoded as a list of operations.  */
int dwarf_getlocation (Dwarf_Attribute* attr, Dwarf_Op** expr, size_t* exprlen);

/* Return location expressions.  If the attribute uses a location list,
   ADDRESS selects the relevant location expressions from the list.
   There can be multiple matches, resulting in multiple expressions to
   return.  EXPRS and EXPRLENS are parallel arrays of NLOCS slots to
   fill in.  Returns the number of locations filled in, or -1 for
   errors.  If EXPRS is a null pointer, stores nothing and returns the
   total number of locations.  A return value of zero means that the
   location list indicated no value is accessible.  */
int dwarf_getlocation_addr (
    Dwarf_Attribute* attr,
    Dwarf_Addr address,
    Dwarf_Op** exprs,
    size_t* exprlens,
    size_t nlocs);

/* Enumerate the locations ranges and descriptions covered by the
   given attribute.  In the first call OFFSET should be zero and
   *BASEP need not be initialized.  Returns -1 for errors, zero when
   there are no more locations to report, or a nonzero OFFSET
   value to pass to the next call.  Each subsequent call must preserve
   *BASEP from the prior call.  Successful calls fill in *STARTP and
   *ENDP with a contiguous address range and *EXPR with a pointer to
   an array of operations with length *EXPRLEN.  If the attribute
   describes a single location description and not a location list the
   first call (with OFFSET zero) will return the location description
   in *EXPR with *STARTP set to zero and *ENDP set to minus one.  */
ptrdiff_t dwarf_getlocations (
    Dwarf_Attribute* attr,
    ptrdiff_t offset,
    Dwarf_Addr* basep,
    Dwarf_Addr* startp,
    Dwarf_Addr* endp,
    Dwarf_Op** expr,
    size_t* exprlen);

/* Return the block associated with a DW_OP_implicit_value operation.
   The OP pointer must point into an expression that dwarf_getlocation
   or dwarf_getlocation_addr has returned given the same ATTR.  */
int dwarf_getlocation_implicit_value (
    Dwarf_Attribute* attr,
    const(Dwarf_Op)* op,
    Dwarf_Block* return_block);

/* Return the attribute indicated by a DW_OP_GNU_implicit_pointer operation.
   The OP pointer must point into an expression that dwarf_getlocation
   or dwarf_getlocation_addr has returned given the same ATTR.
   The result is the DW_AT_location or DW_AT_const_value attribute
   of the OP->number DIE.  */
int dwarf_getlocation_implicit_pointer (
    Dwarf_Attribute* attr,
    const(Dwarf_Op)* op,
    Dwarf_Attribute* result);

/* Return the DIE associated with an operation such as
   DW_OP_GNU_implicit_pointer, DW_OP_GNU_parameter_ref, DW_OP_GNU_convert,
   DW_OP_GNU_reinterpret, DW_OP_GNU_const_type, DW_OP_GNU_regval_type or
   DW_OP_GNU_deref_type.  The OP pointer must point into an expression that
   dwarf_getlocation or dwarf_getlocation_addr has returned given the same
   ATTR.  The RESULT is a DIE that expresses a type or value needed by the
   given OP.  */
int dwarf_getlocation_die (
    Dwarf_Attribute* attr,
    const(Dwarf_Op)* op,
    Dwarf_Die* result);

/* Return the attribute expressing a value associated with an operation such
   as DW_OP_implicit_value, DW_OP_GNU_entry_value or DW_OP_GNU_const_type.
   The OP pointer must point into an expression that dwarf_getlocation
   or dwarf_getlocation_addr has returned given the same ATTR.
   The RESULT is a value expressed by an attribute such as DW_AT_location
   or DW_AT_const_value.  */
int dwarf_getlocation_attr (
    Dwarf_Attribute* attr,
    const(Dwarf_Op)* op,
    Dwarf_Attribute* result);

/* Compute the byte-size of a type DIE according to DWARF rules.
   For most types, this is just DW_AT_byte_size.
   For DW_TAG_array_type it can apply much more complex rules.  */
int dwarf_aggregate_size (Dwarf_Die* die, Dwarf_Word* size);

/* Given a language code, as returned by dwarf_srclan, get the default
   lower bound for a subrange type without a lower bound attribute.
   Returns zero on success or -1 on failure when the given language
   wasn't recognized.  */
int dwarf_default_lower_bound (int lang, Dwarf_Sword* result);

/* Return scope DIEs containing PC address.
   Sets *SCOPES to a malloc'd array of Dwarf_Die structures,
   and returns the number of elements in the array.
   (*SCOPES)[0] is the DIE for the innermost scope containing PC,
   (*SCOPES)[1] is the DIE for the scope containing that scope, and so on.
   Returns -1 for errors or 0 if no scopes match PC.  */
int dwarf_getscopes (Dwarf_Die* cudie, Dwarf_Addr pc, Dwarf_Die** scopes);

/* Return scope DIEs containing the given DIE.
   Sets *SCOPES to a malloc'd array of Dwarf_Die structures,
   and returns the number of elements in the array.
   (*SCOPES)[0] is a copy of DIE.
   (*SCOPES)[1] is the DIE for the scope containing that scope, and so on.
   Returns -1 for errors or 0 if DIE is not found in any scope entry.  */
int dwarf_getscopes_die (Dwarf_Die* die, Dwarf_Die** scopes);

/* Search SCOPES[0..NSCOPES-1] for a variable called NAME.
   Ignore the first SKIP_SHADOWS scopes that match the name.
   If MATCH_FILE is not null, accept only declaration in that source file;
   if MATCH_LINENO or MATCH_LINECOL are also nonzero, accept only declaration
   at that line and column.

   If successful, fill in *RESULT with the DIE of the variable found,
   and return N where SCOPES[N] is the scope defining the variable.
   Return -1 for errors or -2 for no matching variable found.  */
int dwarf_getscopevar (
    Dwarf_Die* scopes,
    int nscopes,
    const(char)* name,
    int skip_shadows,
    const(char)* match_file,
    int match_lineno,
    int match_linecol,
    Dwarf_Die* result);

/* Return list address ranges.  */
int dwarf_getaranges (Dwarf* dbg, Dwarf_Aranges** aranges, size_t* naranges);

/* Return one of the address range entries.  */
Dwarf_Arange* dwarf_onearange (Dwarf_Aranges* aranges, size_t idx);

/* Return information in address range record.  */
int dwarf_getarangeinfo (
    Dwarf_Arange* arange,
    Dwarf_Addr* addrp,
    Dwarf_Word* lengthp,
    Dwarf_Off* offsetp);

/* Get address range which includes given address.  */
Dwarf_Arange* dwarf_getarange_addr (Dwarf_Aranges* aranges, Dwarf_Addr addr);

/* Get functions in CUDIE.  The given callback will be called for all
   defining DW_TAG_subprograms in the CU DIE tree.  If the callback
   returns DWARF_CB_ABORT the return value can be used as offset argument
   to resume the function to find all remaining functions (this is not
   really recommended, since it needs to rewalk the CU DIE tree first till
   that offset is found again).  If the callback returns DWARF_CB_OK
   dwarf_getfuncs will not return but keep calling the callback for each
   function DIE it finds.  Pass zero for offset on the first call to walk
   the full CU DIE tree.  If no more functions can be found and the callback
   returned DWARF_CB_OK then the function returns zero.  */
ptrdiff_t dwarf_getfuncs (
    Dwarf_Die* cudie,
    int function (Dwarf_Die*, void*) callback,
    void* arg,
    ptrdiff_t offset);

/* Return file name containing definition of the given declaration.
   Of the DECL has an (indirect, see dwarf_attr_integrate) decl_file
   attribute.  The returned file path is either absolute, or relative
   to the compilation directory.  Given the decl DIE, the compilation
   directory can be retrieved through:
   dwarf_formstring (dwarf_attr (dwarf_diecu (decl, &cudie, NULL, NULL),
                                 DW_AT_comp_dir, &attr));
   Returns NULL if no decl_file could be found or an error occured.  */
const(char)* dwarf_decl_file (Dwarf_Die* decl);

/* Get line number of beginning of given declaration.  */
int dwarf_decl_line (Dwarf_Die* decl, int* linep);

/* Get column number of beginning of given declaration.  */
int dwarf_decl_column (Dwarf_Die* decl, int* colp);

/* Return nonzero if given function is an abstract inline definition.  */
int dwarf_func_inline (Dwarf_Die* func);

/* Find each concrete inlined instance of the abstract inline definition.  */
int dwarf_func_inline_instances (
    Dwarf_Die* func,
    int function (Dwarf_Die*, void*) callback,
    void* arg);

/* Find the appropriate PC location or locations for function entry
   breakpoints for the given DW_TAG_subprogram DIE.  Returns -1 for errors.
   On success, returns the number of breakpoint locations (never zero)
   and sets *BKPTS to a malloc'd vector of addresses.  */
int dwarf_entry_breakpoints (Dwarf_Die* die, Dwarf_Addr** bkpts);

/* Iterate through the macro unit referenced by CUDIE and call
   CALLBACK for each macro information entry.  To start the iteration,
   one would pass DWARF_GETMACROS_START for TOKEN.

   The iteration continues while CALLBACK returns DWARF_CB_OK.  If the
   callback returns DWARF_CB_ABORT, the iteration stops and a
   continuation token is returned, which can be used to restart the
   iteration at the point where it ended.  Returns -1 for errors or 0
   if there are no more macro entries.

   Note that the Dwarf_Macro pointer passed to the callback is only
   valid for the duration of the callback invocation.

   For backward compatibility, a token of 0 is accepted for starting
   the iteration as well, but in that case this interface will refuse
   to serve opcode 0xff from .debug_macro sections.  Such opcode would
   be considered invalid and would cause dwarf_getmacros to return
   with error.  */

ptrdiff_t dwarf_getmacros (
    Dwarf_Die* cudie,
    int function (Dwarf_Macro*, void*) callback,
    void* arg,
    ptrdiff_t token);

/* This is similar in operation to dwarf_getmacros, but selects the
   unit to iterate through by offset instead of by CU, and always
   iterates .debug_macro.  This can be used for handling
   DW_MACRO_GNU_transparent_include's or similar opcodes.

   TOKEN value of DWARF_GETMACROS_START can be used to start the
   iteration.

   It is not appropriate to obtain macro unit offset by hand from a CU
   DIE and then request iteration through this interface.  The reason
   for this is that if a dwarf_macro_getsrcfiles is later called,
   there would be no way to figure out what DW_AT_comp_dir was present
   on the CU DIE, and file names referenced in either the macro unit
   itself, or the .debug_line unit that it references, might be wrong.
   Use dwarf_getmacros.  */
ptrdiff_t dwarf_getmacros_off (
    Dwarf* dbg,
    Dwarf_Off macoff,
    int function (Dwarf_Macro*, void*) callback,
    void* arg,
    ptrdiff_t token);

/* Get the source files used by the macro entry.  You shouldn't assume
   that Dwarf_Files references will remain valid after MACRO becomes
   invalid.  (Which is to say it's only valid within the
   dwarf_getmacros* callback.)  Returns 0 for success or a negative
   value in case of an error.  */
int dwarf_macro_getsrcfiles (
    Dwarf* dbg,
    Dwarf_Macro* macro_,
    Dwarf_Files** files,
    size_t* nfiles);

/* Return macro opcode.  That's a constant that can be either from
   DW_MACINFO_* domain or DW_MACRO_GNU_* domain.  The two domains have
   compatible values, so it's OK to use either of them for
   comparisons.  The only differences is 0xff, which could be either
   DW_MACINFO_vendor_ext or a vendor-defined DW_MACRO_* constant.  One
   would need to look if the CU DIE which the iteration was requested
   for has attribute DW_AT_macro_info, or either of DW_AT_GNU_macros
   or DW_AT_macros to differentiate the two interpretations.  */
int dwarf_macro_opcode (Dwarf_Macro* macro_, uint* opcodep);

/* Get number of parameters of MACRO and store it to *PARAMCNTP.  */
int dwarf_macro_getparamcnt (Dwarf_Macro* macro_, size_t* paramcntp);

/* Get IDX-th parameter of MACRO (numbered from zero), and stores it
   to *ATTRIBUTE.  Returns 0 on success or -1 for errors.

   After a successful call, you can query ATTRIBUTE by dwarf_whatform
   to determine which of the dwarf_formX calls to make to get actual
   value out of ATTRIBUTE.  Note that calling dwarf_whatattr is not
   meaningful for pseudo-attributes formed this way.  */
int dwarf_macro_param (
    Dwarf_Macro* macro_,
    size_t idx,
    Dwarf_Attribute* attribute);

/* Return macro parameter with index 0.  This will return -1 if the
   parameter is not an integral value.  Use dwarf_macro_param for more
   general access.  */
int dwarf_macro_param1 (Dwarf_Macro* macro_, Dwarf_Word* paramp);

/* Return macro parameter with index 1.  This will return -1 if the
   parameter is not an integral or string value.  Use
   dwarf_macro_param for more general access.  */
int dwarf_macro_param2 (
    Dwarf_Macro* macro_,
    Dwarf_Word* paramp,
    const(char*)* strp);

/* Compute what's known about a call frame when the PC is at ADDRESS.
   Returns 0 for success or -1 for errors.
   On success, *FRAME is a malloc'd pointer.  */
int dwarf_cfi_addrframe (
    Dwarf_CFI* cache,
    Dwarf_Addr address,
    Dwarf_Frame** frame);

/* Return the DWARF register number used in FRAME to denote
   the return address in FRAME's caller frame.  The remaining
   arguments can be non-null to fill in more information.

   Fill [*START, *END) with the PC range to which FRAME's information applies.
   Fill in *SIGNALP to indicate whether this is a signal-handling frame.
   If true, this is the implicit call frame that calls a signal handler.
   This frame's "caller" is actually the interrupted state, not a call;
   its return address is an exact PC, not a PC after a call instruction.  */
int dwarf_frame_info (
    Dwarf_Frame* frame,
    Dwarf_Addr* start,
    Dwarf_Addr* end,
    bool* signalp);

/* Return a DWARF expression that yields the Canonical Frame Address at
   this frame state.  Returns -1 for errors, or zero for success, with
   *NOPS set to the number of operations stored at *OPS.  That pointer
   can be used only as long as FRAME is alive and unchanged.  *NOPS is
   zero if the CFA cannot be determined here.  Note that if nonempty,
   *OPS is a DWARF expression, not a location description--append
   DW_OP_stack_value to a get a location description for the CFA.  */
int dwarf_frame_cfa (Dwarf_Frame* frame, Dwarf_Op** ops, size_t* nops);

/* Deliver a DWARF location description that yields the location or
   value of DWARF register number REGNO in the state described by FRAME.

   Returns -1 for errors or zero for success, setting *NOPS to the
   number of operations in the array stored at *OPS.  Note the last
   operation is DW_OP_stack_value if there is no mutable location but
   only a computable value.

   *NOPS zero with *OPS set to OPS_MEM means CFI says the caller's
   REGNO is "undefined", i.e. it's call-clobbered and cannot be recovered.

   *NOPS zero with *OPS set to a null pointer means CFI says the
   caller's REGNO is "same_value", i.e. this frame did not change it;
   ask the caller frame where to find it.

   For common simple expressions *OPS is OPS_MEM.  For arbitrary DWARF
   expressions in the CFI, *OPS is an internal pointer that can be used as
   long as the Dwarf_CFI used to create FRAME remains alive.  */
int dwarf_frame_register (
    Dwarf_Frame* frame,
    int regno,
    ref Dwarf_Op[3] ops_mem,
    Dwarf_Op** ops,
    size_t* nops);

/* Return error code of last failing function call.  This value is kept
   separately for each thread.  */
int dwarf_errno ();

/* Return error string for ERROR.  If ERROR is zero, return error string
   for most recent error or NULL is none occurred.  If ERROR is -1 the
   behaviour is similar to the last case except that not NULL but a legal
   string is returned.  */
const(char)* dwarf_errmsg (int err);

/* Register new Out-Of-Memory handler.  The old handler is returned.  */
Dwarf_OOM dwarf_new_oom_handler (Dwarf* dbg, Dwarf_OOM handler);
//enum DW_TAG_invalid = .DW_TAG_invalid;
enum DWARF_END_ABBREV = cast(Dwarf_Abbrev*) -1L;
enum DWARF_END_DIE = cast(Dwarf_Die*) -1L;
enum LIBDW_CIE_ID = 0xffffffffffffffffUL;

extern (D) auto dwarf_cfi_cie_p(T)(auto ref T entry)
{
    return entry.cie.CIE_id == LIBDW_CIE_ID;
}

enum DWARF_GETMACROS_START = PTRDIFF_MIN;

/* Inline optimizations.  */

/* Return attribute code of given attribute.  */

/* Return attribute code of given attribute.  */

/* Optimize.  */

/* libdw.h */
