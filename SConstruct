# vim: ft=python expandtab
import os
import re
from site_init import GBuilder, Initialize

opts = Variables()
opts.Add(PathVariable('PREFIX', 'Installation prefix', os.path.expanduser('~/FOSS'), PathVariable.PathIsDirCreate))
opts.Add(BoolVariable('DEBUG', 'Build with Debugging information', 0))
opts.Add(PathVariable('PERL', 'Path to the executable perl', r'C:\Perl\bin\perl.exe', PathVariable.PathIsFile))
opts.Add(PathVariable('PYTHON_INCLUDE', 'Path to the python include directory', r'C:\Python26\include', PathVariable.PathIsDir))
opts.Add(PathVariable('PYTHON_LIB', 'Path to the python library directory', r'C:\Python26\lib', PathVariable.PathIsDir))
opts.Add(BoolVariable('WITH_TRIO_SOURCES', 'Path to the python library directory', 0))

env = Environment(variables = opts,
                  ENV=os.environ, tools = ['default', GBuilder])

Initialize(env)
env.Append(CPPPATH=['#'])
env.Append(CFLAGS=env['DEBUG_CFLAGS'])
env.Append(CPPDEFINES=env['DEBUG_CPPDEFINES'])

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

env.ParseConfig('pkg-config zlib --cflags --libs')
dll = env.SharedLibrary(['libxml2' + env['LIB_SUFFIX'] + '.dll', 'xml2.lib'], libxml2_SOURCES)
env.AddPostAction(dll, 'mt.exe -nologo -manifest ${TARGET}.manifest -outputresource:$TARGET;2')

env.Append(CPPPATH='include')
env.Append(CPPDEFINES=['WIN32',
                       'LIBXML_TREE_ENABLED',
                       'LIBXML_OUTPUT_ENABLED',
                       'LIBXML_PUSH_ENABLED',
                       'LIBXML_READER_ENABLED',
                       'LIBXML_PATTERN_ENABLED',
                       'LIBXML_WRITER_ENABLED',
                       'LIBXML_SAX1_ENABLED'])
env.Append(LIBS = ['Ws2_32'])
env.Alias('install', env.Install('$PREFIX/bin', 'libxml2' + env['LIB_SUFFIX'] + '.dll'))
env.Alias('install', env.Install('$PREFIX/lib', 'xml2.lib'))
env.Alias('install', env.InstallAs('$PREFIX/lib/libxml2.lib', 'xml2.lib'))
SConscript(['include/libxml/SConscript'], exports = 'env')
