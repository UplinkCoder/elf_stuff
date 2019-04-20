/* Interface for libelf.
   Copyright (C) 1998-2010, 2015 Red Hat, Inc.
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

module elfutils.libelf;

import elfutils.elf;

import core.stdc.config;
import core.stdc.time;
import core.sys.posix.sys.types;

extern (C):

enum _LIBELF_H = 1;

/* Get the ELF types.  */

/* Older glibc elf.h might not yet define the ELF compression types.  */
/* Section with compressed data. */

/* Section compression header.  Used when SHF_COMPRESSED is set.  */

/* Compression format.  */
/* Uncompressed data size.  */
/* Uncompressed data alignment.  */

/* Compression format.  */

/* Uncompressed data size.  */
/* Uncompressed data alignment.  */

/* Legal values for ch_type (compression algorithm).  */
/* ZLIB/DEFLATE algorithm.  */
/* Start of OS-specific.  */
/* End of OS-specific.  */
/* Start of processor-specific.  */
/* End of processor-specific.  */

/* Known translation types.  */
enum Elf_Type
{
    ELF_T_BYTE = 0, /* unsigned char */
    ELF_T_ADDR = 1, /* Elf32_Addr, Elf64_Addr, ... */
    ELF_T_DYN = 2, /* Dynamic section record.  */
    ELF_T_EHDR = 3, /* ELF header.  */
    ELF_T_HALF = 4, /* Elf32_Half, Elf64_Half, ... */
    ELF_T_OFF = 5, /* Elf32_Off, Elf64_Off, ... */
    ELF_T_PHDR = 6, /* Program header.  */
    ELF_T_RELA = 7, /* Relocation entry with addend.  */
    ELF_T_REL = 8, /* Relocation entry.  */
    ELF_T_SHDR = 9, /* Section header.  */
    ELF_T_SWORD = 10, /* Elf32_Sword, Elf64_Sword, ... */
    ELF_T_SYM = 11, /* Symbol record.  */
    ELF_T_WORD = 12, /* Elf32_Word, Elf64_Word, ... */
    ELF_T_XWORD = 13, /* Elf32_Xword, Elf64_Xword, ... */
    ELF_T_SXWORD = 14, /* Elf32_Sxword, Elf64_Sxword, ... */
    ELF_T_VDEF = 15, /* Elf32_Verdef, Elf64_Verdef, ... */
    ELF_T_VDAUX = 16, /* Elf32_Verdaux, Elf64_Verdaux, ... */
    ELF_T_VNEED = 17, /* Elf32_Verneed, Elf64_Verneed, ... */
    ELF_T_VNAUX = 18, /* Elf32_Vernaux, Elf64_Vernaux, ... */
    ELF_T_NHDR = 19, /* Elf32_Nhdr, Elf64_Nhdr, ... */
    ELF_T_SYMINFO = 20, /* Elf32_Syminfo, Elf64_Syminfo, ... */
    ELF_T_MOVE = 21, /* Elf32_Move, Elf64_Move, ... */
    ELF_T_LIB = 22, /* Elf32_Lib, Elf64_Lib, ... */
    ELF_T_GNUHASH = 23, /* GNU-style hash section.  */
    ELF_T_AUXV = 24, /* Elf32_auxv_t, Elf64_auxv_t, ... */
    ELF_T_CHDR = 25, /* Compressed, Elf32_Chdr, Elf64_Chdr, ... */
    ELF_T_NHDR8 = 26, /* Special GNU Properties note.  Same as Nhdr,
    				   except padding.  */
    /* Keep this the last entry.  */
    ELF_T_NUM = 27
}

/* Descriptor for data to be converted to or from memory format.  */
struct Elf_Data
{
    void* d_buf; /* Pointer to the actual data.  */
    Elf_Type d_type; /* Type of this piece of data.  */
    uint d_version; /* ELF version.  */
    size_t d_size; /* Size in bytes.  */
    long d_off; /* Offset into section.  */
    size_t d_align; /* Alignment in section.  */
}

/* Commands for `...'.  */
enum Elf_Cmd
{
    ELF_C_NULL = 0, /* Nothing, terminate, or compute only.  */
    ELF_C_READ = 1, /* Read .. */
    ELF_C_RDWR = 2, /* Read and write .. */
    ELF_C_WRITE = 3, /* Write .. */
    ELF_C_CLR = 4, /* Clear flag.  */
    ELF_C_SET = 5, /* Set flag.  */
    ELF_C_FDDONE = 6, /* Signal that file descriptor will not be
    				   used anymore.  */
    ELF_C_FDREAD = 7, /* Read rest of data so that file descriptor
    				   is not used anymore.  */
    /* The following are extensions.  */
    ELF_C_READ_MMAP = 8, /* Read, but mmap the file if possible.  */
    ELF_C_RDWR_MMAP = 9, /* Read and write, with mmap.  */
    ELF_C_WRITE_MMAP = 10, /* Write, with mmap.  */
    ELF_C_READ_MMAP_PRIVATE = 11, /* Read, but memory is writable, results are
    				   not written to the file.  */
    ELF_C_EMPTY = 12, /* Copy basic file data but not the content. */
    /* Keep this the last entry.  */
    ELF_C_NUM = 13
}

/* Flags for the ELF structures.  */
enum
{
    ELF_F_DIRTY = 0x1,

    ELF_F_LAYOUT = 0x4,

    ELF_F_PERMISSIVE = 0x8
}

//enum ELF_F_DIRTY = .ELF_F_DIRTY;
//enum ELF_F_LAYOUT = .ELF_F_LAYOUT;
//enum ELF_F_PERMISSIVE = .ELF_F_PERMISSIVE;

/* Flags for elf_compress[_gnu].  */
enum
{
    ELF_CHF_FORCE = 0x1
}

//enum ELF_CHF_FORCE = .ELF_CHF_FORCE;

/* Identification values for recognized object files.  */
enum Elf_Kind
{
    ELF_K_NONE = 0, /* Unknown.  */
    ELF_K_AR = 1, /* Archive.  */
    ELF_K_COFF = 2, /* Stupid old COFF.  */
    ELF_K_ELF = 3, /* ELF file.  */
    /* Keep this the last entry.  */
    ELF_K_NUM = 4
}

/* Archive member header.  */
struct Elf_Arhdr
{
    char* ar_name; /* Name of archive member.  */
    time_t ar_date; /* File date.  */
    uid_t ar_uid; /* User ID.  */
    gid_t ar_gid; /* Group ID.  */
    mode_t ar_mode; /* File mode.  */
    long ar_size; /* File size.  */
    char* ar_rawname; /* Original name of archive member.  */
}

/* Archive symbol table entry.  */
struct Elf_Arsym
{
    char* as_name; /* Symbol name.  */
    size_t as_off; /* Offset for this file in the archive.  */
    c_ulong as_hash; /* Hash value of the name.  */
}

/* Descriptor for the ELF file.  */
struct Elf;

/* Descriptor for ELF file section.  */
struct Elf_Scn;

/* Return descriptor for ELF file to work according to CMD.  */
Elf* elf_begin (int __fildes, Elf_Cmd __cmd, Elf* __ref);

/* Create a clone of an existing ELF descriptor.  */
Elf* elf_clone (Elf* __elf, Elf_Cmd __cmd);

/* Create descriptor for memory region.  */
Elf* elf_memory (char* __image, size_t __size);

/* Advance archive descriptor to next element.  */
Elf_Cmd elf_next (Elf* __elf);

/* Free resources allocated for ELF.  */
int elf_end (Elf* __elf);

/* Update ELF descriptor and write file to disk.  */
long elf_update (Elf* __elf, Elf_Cmd __cmd);

/* Determine what kind of file is associated with ELF.  */
Elf_Kind elf_kind (Elf* __elf);

/* Get the base offset for an object file.  */
long elf_getbase (Elf* __elf);

/* Retrieve file identification data.  */
char* elf_getident (Elf* __elf, size_t* __nbytes);

/* Retrieve class-dependent object file header.  */
Elf32_Ehdr* elf32_getehdr (Elf* __elf);
/* Similar but this time the binary calls is ELFCLASS64.  */
Elf64_Ehdr* elf64_getehdr (Elf* __elf);

/* Create ELF header if none exists.  */
Elf32_Ehdr* elf32_newehdr (Elf* __elf);
/* Similar but this time the binary calls is ELFCLASS64.  */
Elf64_Ehdr* elf64_newehdr (Elf* __elf);

/* Get the number of program headers in the ELF file.  If the file uses
   more headers than can be represented in the e_phnum field of the ELF
   header the information from the sh_info field in the zeroth section
   header is used.  */
int elf_getphdrnum (Elf* __elf, size_t* __dst);

/* Retrieve class-dependent program header table.  */
Elf32_Phdr* elf32_getphdr (Elf* __elf);
/* Similar but this time the binary calls is ELFCLASS64.  */
Elf64_Phdr* elf64_getphdr (Elf* __elf);

/* Create ELF program header.  */
Elf32_Phdr* elf32_newphdr (Elf* __elf, size_t __cnt);
/* Similar but this time the binary calls is ELFCLASS64.  */
Elf64_Phdr* elf64_newphdr (Elf* __elf, size_t __cnt);

/* Get section at INDEX.  */
Elf_Scn* elf_getscn (Elf* __elf, size_t __index);

/* Get section at OFFSET.  */
Elf_Scn* elf32_offscn (Elf* __elf, Elf32_Off __offset);
/* Similar bug this time the binary calls is ELFCLASS64.  */
Elf_Scn* elf64_offscn (Elf* __elf, Elf64_Off __offset);

/* Get index of section.  */
size_t elf_ndxscn (Elf_Scn* __scn);

/* Get section with next section index.  */
Elf_Scn* elf_nextscn (Elf* __elf, Elf_Scn* __scn);

/* Create a new section and append it at the end of the table.  */
Elf_Scn* elf_newscn (Elf* __elf);

/* Get the section index of the extended section index table for the
   given symbol table.  */
int elf_scnshndx (Elf_Scn* __scn);

/* Get the number of sections in the ELF file.  If the file uses more
   sections than can be represented in the e_shnum field of the ELF
   header the information from the sh_size field in the zeroth section
   header is used.  */
int elf_getshdrnum (Elf* __elf, size_t* __dst);
/* Sun messed up the implementation of 'elf_getshnum' in their implementation.
   It was agreed to make the same functionality available under a different
   name and obsolete the old name.  */
int elf_getshnum (Elf* __elf, size_t* __dst);

/* Get the section index of the section header string table in the ELF
   file.  If the index cannot be represented in the e_shstrndx field of
   the ELF header the information from the sh_link field in the zeroth
   section header is used.  */
int elf_getshdrstrndx (Elf* __elf, size_t* __dst);
/* Sun messed up the implementation of 'elf_getshstrndx' in their
   implementation.  It was agreed to make the same functionality available
   under a different name and obsolete the old name.  */
int elf_getshstrndx (Elf* __elf, size_t* __dst);

/* Retrieve section header of ELFCLASS32 binary.  */
Elf32_Shdr* elf32_getshdr (Elf_Scn* __scn);
/* Similar for ELFCLASS64.  */
Elf64_Shdr* elf64_getshdr (Elf_Scn* __scn);

/* Returns compression header for a section if section data is
   compressed.  Returns NULL and sets elf_errno if the section isn't
   compressed or an error occurred.  */
Elf32_Chdr* elf32_getchdr (Elf_Scn* __scn);
Elf64_Chdr* elf64_getchdr (Elf_Scn* __scn);

/* Compress or decompress the data of a section and adjust the section
   header.

   elf_compress works by setting or clearing the SHF_COMPRESS flag
   from the section Shdr and will encode or decode a Elf32_Chdr or
   Elf64_Chdr at the start of the section data.  elf_compress_gnu will
   encode or decode any section, but is traditionally only used for
   sections that have a name starting with ".debug" when
   uncompressed or ".zdebug" when compressed and stores just the
   uncompressed size.  The GNU compression method is deprecated and
   should only be used for legacy support.

   elf_compress takes a compression type that should be either zero to
   decompress or an ELFCOMPRESS algorithm to use for compression.
   Currently only ELFCOMPRESS_ZLIB is supported.  elf_compress_gnu
   will compress in the traditional GNU compression format when
   compress is one and decompress the section data when compress is
   zero.

   The FLAGS argument can be zero or ELF_CHF_FORCE.  If FLAGS contains
   ELF_CHF_FORCE then it will always compress the section, even if
   that would not reduce the size of the data section (including the
   header).  Otherwise elf_compress and elf_compress_gnu will compress
   the section only if the total data size is reduced.

   On successful compression or decompression the function returns
   one.  If (not forced) compression is requested and the data section
   would not actually reduce in size, the section is not actually
   compressed and zero is returned.  Otherwise -1 is returned and
   elf_errno is set.

   It is an error to request compression for a section that already
   has SHF_COMPRESSED set, or (for elf_compress) to request
   decompression for an section that doesn't have SHF_COMPRESSED set.
   If a section has SHF_COMPRESSED set then calling elf_compress_gnu
   will result in an error.  The section has to be decompressed first
   using elf_compress.  Calling elf_compress on a section compressed
   with elf_compress_gnu is fine, but probably useless.

   It is always an error to call these functions on SHT_NOBITS
   sections or if the section has the SHF_ALLOC flag set.
   elf_compress_gnu will not check whether the section name starts
   with ".debug" or .zdebug".  It is the responsibilty of the caller
   to make sure the deprecated GNU compression method is only called
   on correctly named sections (and to change the name of the section
   when using elf_compress_gnu).

   All previous returned Shdrs and Elf_Data buffers are invalidated by
   this call and should no longer be accessed.

   Note that although this changes the header and data returned it
   doesn't mark the section as dirty.  To keep the changes when
   calling elf_update the section has to be flagged ELF_F_DIRTY.  */
int elf_compress (Elf_Scn* scn, int type, uint flags);
int elf_compress_gnu (Elf_Scn* scn, int compress, uint flags);

/* Set or clear flags for ELF file.  */
uint elf_flagelf (Elf* __elf, Elf_Cmd __cmd, uint __flags);
/* Similarly for the ELF header.  */
uint elf_flagehdr (Elf* __elf, Elf_Cmd __cmd, uint __flags);
/* Similarly for the ELF program header.  */
uint elf_flagphdr (Elf* __elf, Elf_Cmd __cmd, uint __flags);
/* Similarly for the given ELF section.  */
uint elf_flagscn (Elf_Scn* __scn, Elf_Cmd __cmd, uint __flags);
/* Similarly for the given ELF data.  */
uint elf_flagdata (Elf_Data* __data, Elf_Cmd __cmd, uint __flags);
/* Similarly for the given ELF section header.  */
uint elf_flagshdr (Elf_Scn* __scn, Elf_Cmd __cmd, uint __flags);

/* Get data from section while translating from file representation to
   memory representation.  The Elf_Data d_type is set based on the
   section type if known.  Otherwise d_type is set to ELF_T_BYTE.  If
   the section contains compressed data then d_type is always set to
   ELF_T_CHDR.  */
Elf_Data* elf_getdata (Elf_Scn* __scn, Elf_Data* __data);

/* Get uninterpreted section content.  */
Elf_Data* elf_rawdata (Elf_Scn* __scn, Elf_Data* __data);

/* Create new data descriptor for section SCN.  */
Elf_Data* elf_newdata (Elf_Scn* __scn);

/* Get data translated from a chunk of the file contents as section data
   would be for TYPE.  The resulting Elf_Data pointer is valid until
   elf_end (ELF) is called.  */
Elf_Data* elf_getdata_rawchunk (
    Elf* __elf,
    long __offset,
    size_t __size,
    Elf_Type __type);

/* Return pointer to string at OFFSET in section INDEX.  */
char* elf_strptr (Elf* __elf, size_t __index, size_t __offset);

/* Return header of archive.  */
Elf_Arhdr* elf_getarhdr (Elf* __elf);

/* Return offset in archive for current file ELF.  */
long elf_getaroff (Elf* __elf);

/* Select archive element at OFFSET.  */
size_t elf_rand (Elf* __elf, size_t __offset);

/* Get symbol table of archive.  */
Elf_Arsym* elf_getarsym (Elf* __elf, size_t* __narsyms);

/* Control ELF descriptor.  */
int elf_cntl (Elf* __elf, Elf_Cmd __cmd);

/* Retrieve uninterpreted file contents.  */
char* elf_rawfile (Elf* __elf, size_t* __nbytes);

/* Return size of array of COUNT elements of the type denoted by TYPE
   in the external representation.  The binary class is taken from ELF.
   The result is based on version VERSION of the ELF standard.  */
size_t elf32_fsize (Elf_Type __type, size_t __count, uint __version);
/* Similar but this time the binary calls is ELFCLASS64.  */
size_t elf64_fsize (Elf_Type __type, size_t __count, uint __version);

/* Convert data structure from the representation in the file represented
   by ELF to their memory representation.  */
Elf_Data* elf32_xlatetom (
    Elf_Data* __dest,
    const(Elf_Data)* __src,
    uint __encode);
/* Same for 64 bit class.  */
Elf_Data* elf64_xlatetom (
    Elf_Data* __dest,
    const(Elf_Data)* __src,
    uint __encode);

/* Convert data structure from to the representation in memory
   represented by ELF file representation.  */
Elf_Data* elf32_xlatetof (
    Elf_Data* __dest,
    const(Elf_Data)* __src,
    uint __encode);
/* Same for 64 bit class.  */
Elf_Data* elf64_xlatetof (
    Elf_Data* __dest,
    const(Elf_Data)* __src,
    uint __encode);

/* Return error code of last failing function call.  This value is kept
   separately for each thread.  */
int elf_errno ();

/* Return error string for ERROR.  If ERROR is zero, return error string
   for most recent error or NULL is none occurred.  If ERROR is -1 the
   behaviour is similar to the last case except that not NULL but a legal
   string is returned.  */
const(char)* elf_errmsg (int __error);

/* Coordinate ELF library and application versions.  */
uint elf_version (uint __version);

/* Set fill bytes used to fill holes in data structures.  */
void elf_fill (int __fill);

/* Compute hash value.  */
c_ulong elf_hash (const(char)* __string);

/* Compute hash value using the GNU-specific hash function.  */
c_ulong elf_gnu_hash (const(char)* __string);

/* Compute simple checksum from permanent parts of the ELF file.  */
c_long elf32_checksum (Elf* __elf);
/* Similar but this time the binary calls is ELFCLASS64.  */
c_long elf64_checksum (Elf* __elf);

/* libelf.h */
