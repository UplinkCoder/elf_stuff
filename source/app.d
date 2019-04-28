import std.stdio;
import std.file;

import elfutils.libdw;
import dwarf;
import elfutils.libelf;
import elfutils.elf;
import denums;

string enumToString(E)(E v)
{
    static assert(is(E == enum),
        "emumToString is only meant for enums");
    string result;
    
Switch : switch(v)
    {
        foreach(m;__traits(allMembers, E))
        {
            case mixin("E." ~ m) :
            result = m;
            break Switch;
        }
        
        default :
        {
            result = "cast(" ~ E.stringof ~ ")";
            uint val = v;
            enum headLength = cast(uint)(E.stringof.length + "cast()".length);
            uint log10Val = (val < 10) ? 0 : (val < 100) ? 1 : (val < 1000) ? 2 :
            (val < 10000) ? 3 : (val < 100000) ? 4 : (val < 1000000) ? 5 :
            (val < 10000000) ? 6 : (val < 100000000) ? 7 : (val < 1000000000) ? 8 : 9;
            result.length += log10Val + 1;
            for(uint i;i != log10Val + 1;i++)
            {
                cast(char)result[headLength + log10Val - i] = cast(char) ('0' + (val % 10));
                val /= 10;
            }
            
        }
    }
    
    return result;
}


bool isElf(ubyte[] file)
{
    enum hdr = cast(uint) 0x7f | 'E' << 8 | 'L' << 16 | 'F' << 24;
    return file.length > 4 &&
        (*cast(uint*)(file.ptr + EI_MAG0)) == hdr;
}

ElfClassEnum elfClass(ubyte[] file)
{
    return cast(ElfClassEnum) file[EI_CLASS];
}

ElfDataEnum elfData(ubyte[] file)
{
    return cast(ElfDataEnum) file[EI_DATA];
}

ElfOsabiEnum elfOsabi(ubyte[] file)
{
    return cast(ElfOsabiEnum) file[EI_OSABI];
}

align(1) struct ElfHeader
{
    align(1)
    ubyte _7f;
    char[3] _ELF;
    ElfClassEnum e_class;
    ElfDataEnum e_data;
    ubyte e_abi_version;
    ElfOsabiEnum e_osabi;
    ubyte[16 - 8] padding;
    ET e_type;
    EM e_machine;
    uint e_version;
    ulong /*void* */ e_entry; /// pointer representing the offset to the entry_point
    ulong /*size_t */ e_phoff; /// programm header offset
    ulong /*size_t */ e_shoff; /// section header table
    uint e_flags; /// Processor-specific flags
    ushort e_ehsize; /// ELF header size in bytes
    ushort e_phentsize; /// Program header table entry size
    ushort e_phnum; /// Program header table entry count
    ushort e_shentsize; /// Section header table entry size
    ushort e_shnum; /// Section header table entry count
    ushort e_shstrndx; /// Section header string table index
}



struct elf64 {}
struct addr {}
struct offset {}

align(1) struct ElfPHeader
{
    PT p_type;
    @elf64 uint p_flags;
    @offset ulong p_offset;
    @addr ulong p_vaddr;
    @addr ulong p_paddr;
    @offset ulong p_filesz;
    @offset ulong p_memsz;
    @offset ulong p_align;
}

ElfPHeader elfPHdr(ubyte[] file, size_t offset, bool elf64)
{
    ElfPHeader result;

    foreach(i,ref f;result.tupleof)
    {
        static if (__traits(getAttributes, result.tupleof[i]).length)
        {
            foreach(attrib;__traits(getAttributes, result.tupleof[i]))
            {
                static if (is(attrib == .offset) || is(attrib == .addr))
                {

                    f = (file[offset] | file[offset + 1] << 8 | 
                        file[offset + 2] << 16 | file[offset + 3] << 24 | (elf64 ?
                        (ulong(file[offset + 4]) << 32UL | ulong(file[offset + 5]) << 40UL |
                        ulong(file[offset + 6]) << 48UL | ulong(file[offset + 7]) << 56UL)
                        : 0));
                    offset += elf64 ? 8 : 4;

                    pragma(msg, "addr or offset found for ", __traits(identifier, result.tupleof[i]));
                }
                else static if (is(attrib == .elf64))
                {
                    if (elf64)
                    {
                        f = file[offset] | file[offset + 1] << 8 |
                           file[offset + 2] << 16 | file[offset + 3] << 24;
                        offset += 4;
                    }
                }
                else
                {
                    static assert (0, "unknown attrib");
                }
            }
        }
        else
        {
            f = cast(typeof(f)) ( 
                    file[offset] | file[offset + 1] << 8 |
                    file[offset + 2] << 16 | file[offset + 3] << 24
                );
            offset += 4;
            pragma(msg, "no attribs for: ", __traits(identifier, result.tupleof[i]));
        }
    }

    return result;
}

ElfPHeader[] elfPHdrs (ubyte[] file)
{
    auto ehdr = elfEhdr(file);
    return elfPhdrs(ehdr, file);
}

ElfPHeader[] elfPhdrs(ElfHeader ehdr, ubyte[] file)
{
    ElfPHeader[] result;

    ulong currentOffset = ehdr.e_phoff;

    result.length = ehdr.e_phnum;
    bool is64 = 
        ehdr.e_class == ELFCLASS64;
    const phentsize = cast(int)ehdr.e_phentsize;

    foreach(i; 0 .. ehdr.e_phnum)
    {
        result[i] = elfPHdr(file, currentOffset, is64);
        currentOffset += phentsize;
    }

    return result;
}

string printStruct(T)(T _struct)
{
    string result;

    result ~= T.stringof ~ " (";

    foreach(i, e;_struct.tupleof)
    {
        alias type = typeof(_struct.tupleof[i]);
        const fieldName = _struct.tupleof[i].stringof["_struct.".length .. $];

        result ~= "\n\t" ~ fieldName ~ " : ";

        static if (is(type == enum))
        {
            result ~= enumToString(e);
        }
        else
        {
            static if (__traits(getAttributes, _struct.tupleof[i]).length == 1)
            {
                foreach(attrib;__traits(getAttributes, _struct.tupleof[i]))
                {
                    static if (is(attrib == .addr) || is(attrib == .offset) )
                    {
                        import std.conv : to;
                        pragma(msg, "got attrib addr while printing");
                        result ~= to!string(cast(void*)e);
                    }
                    else
                    {
                        import std.conv : to;
                        result ~= to!string(e);
                    }
                }
            }
            else
            {
                import std.conv : to;
                result ~= to!string(e);
            }
        }
    }

    result ~= "\n)";

    return result;
}

ElfHeader elfEhdr(ubyte[] file)
{
    ElfHeader result;

    with(result)
    {
        _7f = file[0];
        _ELF = cast(char[]) file[1 .. 4];
        e_class = cast(ElfClassEnum) file[4];
        e_data = cast(ElfDataEnum) file[5];
        e_abi_version = file[6];
        e_osabi = cast(ElfOsabiEnum) file[7];

        //TODO Endianness 

        e_type = cast(ET) (file[16] | file[17] << 8);
        e_machine = cast(EM) (file[18] | file[19] << 8);
        e_version = (file[20] | file[21] << 8 | 
            file[22] << 16 | file[23] << 24);

        size_t next_offset;

        if (e_class == ELFCLASS64)
        {
            enum fieldSize = ulong.sizeof;

            e_entry = (file[24] | file[25] << 8 | 
                file[26] << 16 | file[27] << 24 |
                (ulong(file[28]) << 32) | (ulong(file[29]) << 40) |
                (ulong(file[30]) << 48) | (ulong(file[31]) << 56));

            e_phoff = (file[32] | file[33] << 8 | 
                file[34] << 16 | file[35] << 24 |
                ulong(file[36]) << 32UL | ulong(file[37]) << 40UL |
                ulong(file[38]) << 48UL | ulong(file[39]) << 56UL);

            e_shoff = (file[40] | file[41] << 8 | 
                file[42] << 16 | file[43] << 24 |
                ulong(file[44]) << 32UL | ulong(file[45]) << 40UL |
                ulong(file[46]) << 48UL | ulong(file[47]) << 56UL);

            
            next_offset = fieldSize*3 + 24;
        }
        else if (e_class == ELFCLASS32)
        {
            enum fieldSize = uint.sizeof;

            e_entry = (file[24] | file[25] << 8 | 
                file[26] << 16 | file[27] << 24);

            e_phoff = (file[28] | file[29] << 8 | 
                file[30] << 16 | file[31] << 24);

            e_shoff = (file[32] | file[33] << 8 | 
                file[34] << 16 | file[35] << 24);

            next_offset = fieldSize*3 + 24;
        }

        else assert(0, "ELFCLASS not supported");

        e_flags = (file[next_offset + 0] |
                file[next_offset + 1] << 8 | 
                file[next_offset + 2] << 16 |
                file[next_offset + 3] << 24);
        next_offset += 4;

        e_ehsize = (file[next_offset + 0] |
            file[next_offset + 1] << 8);
        next_offset += 2;

        e_phentsize = (file[next_offset + 0] |
            file[next_offset + 1] << 8);
        next_offset += 2;

        e_phnum = (file[next_offset + 0] |
            file[next_offset + 1] << 8);
        next_offset += 2;

        e_shentsize = (file[next_offset + 0] |
            file[next_offset + 1] << 8);
        next_offset += 2;

        e_shnum = (file[next_offset + 0] |
            file[next_offset + 1] << 8);
        next_offset += 2;

        e_shstrndx = (file[next_offset + 0] |
            file[next_offset + 1] << 8);
        next_offset += 2;
    }

    return result;
}



void main(string[] args)
{
    printf("%.*s {file.elf}\n", cast(int)args[0].length, args[0].ptr);
    ubyte[] ls = cast(ubyte[]) read("busybox" /*"/lib/ld-linux.so.2"*/);

    if (isElf(ls)) {
        printf("Yes, this is an ELF file!\n");
        auto ec = ls.elfClass;
        writeln("ElfClass: ", ec);
        if (ec == ELFCLASS64 || ec == ELFCLASS32)
        {
            //writeln(ec == ELFCLASS32 ? printStruct(*cast(Elf32_Ehdr*) ls.ptr) : printStruct(*cast(Elf64_Ehdr*) ls.ptr));

            auto ehdr = elfEhdr(ls);

            writeln(printStruct(ehdr), "\n\te_entry as ptr: ", (cast(void*) ehdr.e_entry));
            auto phdrs = elfPhdrs(ehdr, ls);
            foreach(ph; phdrs)
            {
                writeln(printStruct(ph));
            }
        }

        //printf("ELFCLASS: %x, == ELFCLASS64 {%d}", ls[EI_CLASS], ls[EI_CLASS] == ELFCLASS64);
    }
    else
    {
        printf("\nMagic number is not 7f E L F but: \t{%x %c %c %c}\n", ls[EI_MAG0], ls[EI_MAG1], ls[EI_MAG2], ls[EI_MAG3]);
    }

}
