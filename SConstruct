# vim: ft=python expandtab
import os
import re
from site_init import *

opts = Variables()
opts.Add(PathVariable('PREFIX', 'Installation prefix', os.path.expanduser('~/FOSS'), PathVariable.PathIsDirCreate))
opts.Add(BoolVariable('DEBUG', 'Build with Debugging information', 0))
opts.Add(PathVariable('PERL', 'Path to the executable perl', r'C:\Perl\bin\perl.exe', PathVariable.PathIsFile))
opts.Add(PathVariable('PYTHON_INCLUDE', 'Path to the python include directory', r'C:\Python26\include', PathVariable.PathIsDir))
opts.Add(PathVariable('PYTHON_LIB', 'Path to the python library directory', r'C:\Python26\lib', PathVariable.PathIsDir))
opts.Add(BoolVariable('WITH_TRIO_SOURCES', 'build with trio', 0))
opts.Add(BoolVariable('WITH_OSMSVCRT', 'Link with the os supplied msvcrt.dll instead of the one supplied by the compiler (msvcr90.dll, for instance)', 0))

env = Environment(variables = opts,
                  ENV=os.environ, tools = ['default', GBuilder])

Initialize(env)
env.Append(CPPPATH=['#'])
env.Append(CFLAGS=env['DEBUG_CFLAGS'])
env.Append(CPPDEFINES=env['DEBUG_CPPDEFINES'])

if env['WITH_OSMSVCRT']:
    env['LIB_SUFFIX'] = '-2'
    env.Append(CPPDEFINES=['MSVCRT_COMPAT_STAT', 'MSVCRT_COMPAT_SPRINTF'])

LIBXML_MAJOR_VERSION=2
LIBXML_MINOR_VERSION=7
LIBXML_MICRO_VERSION=4

LIBXML_VERSION='%s.%s.%s' % (LIBXML_MAJOR_VERSION, LIBXML_MINOR_VERSION, LIBXML_MICRO_VERSION)
LIBXML_VERSION_NUMBER=str(LIBXML_MAJOR_VERSION * 1000000 +  LIBXML_MINOR_VERSION * 1000 + LIBXML_MICRO_VERSION)

if env['WITH_TRIO_SOURCES'] == 1:
    libxml2_SOURCES = Split("SAX.c entities.c encoding.c error.c parserInternals.c  \
            parser.c tree.c hash.c list.c xmlIO.c xmlmemory.c uri.c  \
            valid.c xlink.c HTMLparser.c HTMLtree.c debugXML.c xpath.c  \
            xpointer.c xinclude.c nanohttp.c nanoftp.c DOCBparser.c \
            catalog.c globals.c threads.c c14n.c xmlstring.c \
            xmlregexp.c xmlschemas.c xmlschemastypes.c xmlunicode.c \
            triostr.c trio.c xmlreader.c relaxng.c dict.c SAX2.c \
            xmlwriter.c legacy.c chvalid.c pattern.c xmlsave.c \
            xmlmodule.c schematron.c")
else:
    libxml2_SOURCES = Split("SAX.c entities.c encoding.c error.c parserInternals.c  \
            parser.c tree.c hash.c list.c xmlIO.c xmlmemory.c uri.c  \
            valid.c xlink.c HTMLparser.c HTMLtree.c debugXML.c xpath.c  \
            xpointer.c xinclude.c nanohttp.c nanoftp.c DOCBparser.c \
            catalog.c globals.c threads.c c14n.c xmlstring.c \
            xmlregexp.c xmlschemas.c xmlschemastypes.c xmlunicode.c \
            xmlreader.c relaxng.c dict.c SAX2.c \
            xmlwriter.c legacy.c chvalid.c pattern.c xmlsave.c \
            xmlmodule.c schematron.c")

env['DOT_IN_SUBS'] = {'@LIBXML_VERSION_NUMBER@': LIBXML_VERSION_NUMBER,
                      '@VERSION@' : LIBXML_VERSION,
                      '@prefix@': env['PREFIX'],
                      '@exec_prefix@' : '${prefix}/bin', 
                      '@libdir@' : '${prefix}/lib', 
                      '@includedir@' : '${prefix}/include',
                      '@XML_INCLUDEDIR@': '-I${includedir}/libxml2',
                      '@Z_LIBS@': '-lz',
                      '@ICONV_LIBS@': '-liconv'
                      }

env.DotIn('include/config.h', 'include/win32config.h')

env.DotIn('libxml-2.0.pc', 'libxml-2.0.pc.in')
env.Alias('install', env.Install('$PREFIX/lib/pkgconfig', 'libxml-2.0.pc'))
env['DOT_IN_SUBS']['@PCS@'] = generate_file_element('libxml-2.0.pc', r'lib/pkgconfig', env)

env.ParseConfig('pkg-config zlib --cflags --libs')
env['PDB']='libxml2.pdb'
env.Append(CPPPATH='include')
env.Append(CPPDEFINES=['WIN32'])
env.Append(LIBS = ['Ws2_32'])
dll = env.SharedLibrary(['libxml2' + env['LIB_SUFFIX'] + '.dll', 'xml2.lib'], libxml2_SOURCES)
env.AddPostAction(dll, 'mt.exe -nologo -manifest ${TARGET}.manifest -outputresource:$TARGET;2')

env_xmllint = env.Clone(PDB='xmllint.pdb')
xmllint = env_xmllint.Program('xmllint.exe', ['xmllint.c', 'xml2.lib'])
env_xmllint.AddPostAction(xmllint, 'mt.exe -nologo -manifest ${TARGET}.manifest -outputresource:$TARGET;2')

env_xmlcatalog = env.Clone(PDB='xmlcatalog.pdb')
xmlcatalog = env_xmlcatalog.Program('xmlcatalog.exe', ['xmlcatalog.c', 'xml2.lib'])
env_xmlcatalog.AddPostAction(xmlcatalog, 'mt.exe -nologo -manifest ${TARGET}.manifest -outputresource:$TARGET;2')

env.Alias('install', env.Install('$PREFIX/bin', ['libxml2' + env['LIB_SUFFIX'] + '.dll', 'xmllint.exe', 'xmlcatalog.exe']))
env['DOT_IN_SUBS']['@DLLS@'] = generate_file_element(['libxml2' + env['LIB_SUFFIX'] + '.dll', 'xmllint.exe', 'xmlcatalog.exe'], r'bin', env)

env.Alias('install', env.Install('$PREFIX/lib', 'xml2.lib'))
env['DOT_IN_SUBS']['@WXSLIBS@'] = generate_file_element(['xml2.lib', 'libxml2.lib'], r'lib', env)
env.Alias('install', env.InstallAs('$PREFIX/lib/libxml2.lib', 'xml2.lib'))
if env['DEBUG']:
    env.Alias('install', env.Install('$PREFIX/pdb', 'libxml2.pdb'))
    env['DOT_IN_SUBS']['@PDBS@'] = generate_file_element(env['PDB'], r'pdb', env)
#SConscript(['include/libxml/SConscript'], exports = 'env')
xmlincdir = '$PREFIX/include/libxml2/libxml'

xmlinc_HEADERS = Split("\
		SAX.h \
		entities.h \
		encoding.h \
		parser.h \
		parserInternals.h \
		xmlerror.h \
		HTMLparser.h \
		HTMLtree.h \
		debugXML.h \
		tree.h \
		list.h \
		hash.h \
		xpath.h \
		xpathInternals.h \
		xpointer.h \
		xinclude.h \
		xmlIO.h \
		xmlmemory.h \
		nanohttp.h \
		nanoftp.h \
		uri.h \
		valid.h \
		xlink.h \
		xmlversion.h \
		DOCBparser.h \
		catalog.h \
		threads.h \
		globals.h \
		c14n.h \
		xmlautomata.h \
		xmlregexp.h \
		xmlmodule.h \
		xmlschemas.h \
		schemasInternals.h \
		xmlschemastypes.h \
		xmlstring.h \
		xmlunicode.h \
		xmlreader.h \
		relaxng.h \
		dict.h \
		SAX2.h \
		xmlexports.h \
		xmlwriter.h \
		chvalid.h \
		pattern.h \
		xmlsave.h \
		schematron.h")

env.DotIn('include/libxml/xmlversion.h', 'include/libxml/xmlwin32version.h.in')
env.Alias('install', env.Install(xmlincdir, map(lambda x: 'include/libxml/' + x, xmlinc_HEADERS)))
env['DOT_IN_SUBS']['@HEADERS@'] = generate_file_element(xmlinc_HEADERS, r'include/libxml2/libxml', env)

env['DOT_IN_SUBS']['@VERSION@'] = LIBXML_VERSION

env.DotIn('libxml2dev.wxs', 'libxml2dev.wxs.in')
env.DotIn('libxml2run.wxs', 'libxml2run.wxs.in')

env.Alias('install', env.Install('$PREFIX/wxs', 'libxml2run.wxs'))
env.Alias('install', env.Install('$PREFIX/wxs', 'libxml2dev.wxs'))
