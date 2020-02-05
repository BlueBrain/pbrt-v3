if(CMAKE_BUILD_TYPE MATCHES RELEASE)
  target_compile_definitions( pbrt PRIVATE -DNDEBUG)
endif()

include (CheckIncludeFiles)

check_include_files ( alloca.h HAVE_ALLOCA_H )
if ( HAVE_ALLOCA_H )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_ALLOCA_H )
endif ()

check_include_files ( memory.h HAVE_MEMORY_H )
if ( HAVE_MEMORY_H )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_MEMORY_H )
endif ()

###########################################################################
# Check for various C++11 features and set preprocessor variables or
# define workarounds.

include (CheckCXXSourceCompiles)
include (CheckCXXSourceRuns)

check_cxx_source_compiles (
  "int main() { float x = 0x1p-32f; }"
  HAVE_HEX_FP_CONSTANTS )
if ( HAVE_HEX_FP_CONSTANTS )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_HEX_FP_CONSTANTS )
endif ()

check_cxx_source_compiles (
  "int main() { int x = 0b101011; }"
  HAVE_BINARY_CONSTANTS )
if ( HAVE_BINARY_CONSTANTS )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_BINARY_CONSTANTS )
endif ()

check_cxx_source_compiles (
  "int main() { constexpr int x = 0; }"
  HAVE_CONSTEXPR )
if ( HAVE_CONSTEXPR )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_CONSTEXPR )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_CONSTEXPR=constexpr )
ELSE ()
  target_compile_definitions ( pbrt PRIVATE -D PBRT_CONSTEXPR=const )
endif ()

check_cxx_source_compiles (
  "struct alignas(32) Foo { char x; }; int main() { }"
  HAVE_ALIGNAS )
if ( HAVE_ALIGNAS )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_ALIGNAS )
endif ()

check_cxx_source_compiles (
  "int main() { int x = alignof(double); }"
  HAVE_ALIGNOF )
if ( HAVE_ALIGNOF )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_ALIGNOF )
endif ()

check_cxx_source_runs ( "
#include <signal.h>
#include <string.h>
#include <sys/time.h>
void ReportProfileSample(int, siginfo_t *, void *) { }
int main() {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_sigaction = ReportProfileSample;
    sa.sa_flags = SA_RESTART | SA_SIGINFO;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGPROF, &sa, NULL);
    static struct itimerval timer;
    return setitimer(ITIMER_PROF, &timer, NULL) == 0 ? 0 : 1;
}
" HAVE_ITIMER )
if ( HAVE_ITIMER )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_ITIMER )
endif()

check_cxx_source_compiles ( "
class Bar { public: Bar() { x = 0; } float x; };
struct Foo { union { int x[10]; Bar b; }; Foo() : b() { } };
int main() { Foo f; }
" HAVE_NONPOD_IN_UNIONS )
if ( HAVE_NONPOD_IN_UNIONS )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_NONPOD_IN_UNIONS )
endif ()

check_cxx_source_compiles ( "
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
int main() {
   int fd = open(\"foo\", O_RDONLY);
   struct stat s;
   fstat(fd, &s);
   size_t len = s.st_size;
   void *ptr = mmap(0, len, PROT_READ, MAP_FILE | MAP_SHARED, fd, 0);
   munmap(ptr, len);   
}
" HAVE_MMAP )
if ( HAVE_MMAP )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_MMAP )
endif ()

########################################
# noinline

check_cxx_source_compiles (
"__declspec(noinline) void foo() { }
int main() { }"
HAVE_DECLSPEC_NOINLINE )

check_cxx_source_compiles (
"__attribute__((noinline)) void foo() { }
int main() { }"
HAVE_ATTRIBUTE_NOINLINE )

if ( HAVE_ATTRIBUTE_NOINLINE )
  target_compile_definitions ( pbrt PRIVATE -D "PBRT_NOINLINE=__attribute__((noinline))" )
  #add_definitions(-D "PBRT_NOINLINE=__attribute__\\(\\(noinline\\)\\)" )
ELSEIF ( HAVE_DECLSPEC_NOINLINE )
  #add_definitions(-D "PBRT_NOINLINE=__declspec(noinline)")
  target_compile_definitions ( pbrt PRIVATE -D "PBRT_NOINLINE=__declspec(noinline)" )
ELSE ()
   #add_definitions( -D PBRT_NOINLINE )
   target_compile_definitions ( pbrt PRIVATE -D PBRT_NOINLINE )
endif ()

########################################
# Aligned memory allocation

check_cxx_source_compiles ( "
#include <malloc.h>
int main() { void * ptr = _aligned_malloc(1024, 32); }
" HAVE__ALIGNED_MALLOC )

check_cxx_source_compiles ( "
#include <stdlib.h>
int main() {
  void *ptr;
  posix_memalign(&ptr, 32, 1024);
} " HAVE_POSIX_MEMALIGN )

check_cxx_source_compiles ( "
#include <malloc.h>
int main() {
    void *ptr = memalign(32, 1024);
} " HAVE_MEMALIGN )

if ( HAVE__ALIGNED_MALLOC )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE__ALIGNED_MALLOC )
ELSEIF ( HAVE_POSIX_MEMALIGN )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_HAVE_POSIX_MEMALIGN )
ELSEIF ( HAVE_MEMALIGN )
  target_compile_definitions ( pbrt PRIVATE -D PBRTHAVE_MEMALIGN )
ELSE ()
  MESSAGE ( SEND_ERROR "Unable to find a way to allocate aligned memory" )
endif ()

########################################
# thread-local variables

check_cxx_source_compiles ( "
#ifdef __CYGWIN__
// Hack to work around https://gcc.gnu.org/bugzilla/show_bug.cgi?id=64697
#error \"No thread_local on cygwin\"
#endif  // __CYGWIN__
thread_local int x; int main() { }
" HAVE_THREAD_LOCAL )

check_cxx_source_compiles ( "
__declspec(thread) int x; int main() { }
" HAVE_DECLSPEC_THREAD )

check_cxx_source_compiles ( "
__thread int x; int main() { }
" HAVE___THREAD )

if ( HAVE_THREAD_LOCAL )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_THREAD_LOCAL=thread_local )
ELSEIF ( HAVE___THREAD )
  target_compile_definitions ( pbrt PRIVATE -D PBRT_THREAD_LOCAL=__thread )
ELSEIF ( HAVE_DECLSPEC_THREAD )
  target_compile_definitions ( pbrt PRIVATE -D "PBRT_THREAD_LOCAL=__declspec(thread)" )
ELSE ()
  MESSAGE ( SEND_ERROR "Unable to find a way to declare a thread-local variable")
endif ()
