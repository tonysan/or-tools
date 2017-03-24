# ---------- CSharp support using SWIG ----------

# Assembly Signing
# ----------------
# All C# assemblies are strongly named by default. This includes the
# DLLs and the test case EXEs.
#
# If you would like to use none strongly named DLLs,
# then please do the following :
# make clean_csharp
# remove the definition of CLR_KEYFILE from Makefile.local
# make csharp
#
# For delay signing, use for example:
# make CLR_KEYFILE="c:\full\path\to\keyfile_pub.snk" CLR_DELAYSIGN=1

ifdef CLR_KEYFILE
ifdef CLR_DELAYSIGN
SIGNING_FLAGS:= /keyfile:"$(CLR_KEYFILE)" /delaysign
else
SIGNING_FLAGS:= /keyfile:"$(CLR_KEYFILE)"
endif
endif

# The generated DLL name. Defaults to Google.OrTools
CLR_PROTOBUF_DLL_NAME?=Google.Protobuf
CLR_ORTOOLS_DLL_NAME?=Google.OrTools
BASE_CLR_ORTOOLS_DLL_NAME:= $(CLR_ORTOOLS_DLL_NAME)
# TODO: TBD: add FlatZinc variables...

# NuGet specification file name
ORTOOLS_NUSPEC_NAME := or-tools.nuspec
ORTOOLS_NUGET_DIR = temp\or-tools
# TODO: TBD: add FlatZinc variables...

# Building to DLLs named per-platform
# -----------------------------------
# If CLR_PER_PLATFORM_ASSEMBLY_NAMING is defined, the generated .NET dll will
# be named with the platform as part of the name: Google.OrTools.x86.dll
# or Google.OrTools.x64.dll. If CLR_PER_PLATFORM_ASSEMBLY_NAMING is not defined,
# the generated .NET dll will be named Google.OrTools.dll regardless of
# the platform. Note that the name is signigicant due to SWIG-generated
# [DllImport] attributes which contain the name of the DLL. Executables will
# be suffixed _x64 in 64-bit builds, no suffix in 32-bit builds.
# This is only available on windows.

ifeq ($(SYSTEM),win)
  ifdef CLR_PER_PLATFORM_ASSEMBLY_NAMING
    ifeq ($(NETPLATFORM),x64)
      CLR_ORTOOLS_DLL_NAME:=$(CLR_ORTOOLS_DLL_NAME).x64
      CLR_EXE_SUFFIX?=_x64
    else
      CLR_ORTOOLS_DLL_NAME:=$(CLR_ORTOOLS_DLL_NAME).x86
    endif
  endif
endif

CSHARPEXE = \
	$(BIN_DIR)/csknapsack$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/csintegerprogramming$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/cslinearprogramming$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/csls_api$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/csflow$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/csrabbitspheasants$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/cstsp$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/furniture_moving_intervals$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/organize_day_intervals$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/techtalk_scheduling$(CLR_EXE_SUFFIX).exe \
	$(BIN_DIR)/cscvrptw$(CLR_EXE_SUFFIX).exe

csharpexe: $(CSHARPEXE)

# Main target.
CANONIC_PATH_TO_CSHARP_COMPILER = $(subst $(SPACE),$(BACKSLASH_SPACE),$(subst \,/,$(subst \\,/,$(PATH_TO_CSHARP_COMPILER))))
ifeq ($(wildcard $(CANONIC_PATH_TO_CSHARP_COMPILER)),)
csharp:
	@echo "The chsarp compiler was not set properly. Check Makefile.local for more information."
test_csharp: csharp

else
csharp: csharpsolution csharportools csharpexe
test_csharp: test_csharp_examples
BUILT_LANGUAGES +=, C\#
endif

# Clean target.
clean_csharp:
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME).$(SWIG_LIB_SUFFIX)
	-$(DEL) $(BIN_DIR)$S$(CLR_ORTOOLS_DLL_NAME)*$(DLL)
	-$(DEL) $(BIN_DIR)$S$(CLR_ORTOOLS_DLL_NAME)*.mdb
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME)*.lib
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME)*.pdb
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME)*.exp
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME)*.netmodule
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc*.lib
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc*.pdb
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc*.exp
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc*.netmodule
	-$(DEL) $(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc.$(SWIG_LIB_SUFFIX)
	-$(DEL) $(GEN_DIR)$Slinear_solver$S*csharp_wrap*
	-$(DEL) $(GEN_DIR)$Sconstraint_solver$S*csharp_wrap*
	-$(DEL) $(GEN_DIR)$Salgorithms$S*csharp_wrap*
	-$(DEL) $(GEN_DIR)$Sgraph$S*csharp_wrap*
	-$(DEL) $(GEN_DIR)$Sflatzinc$S*csharp_wrap*
	-$(DEL) $(GEN_DIR)$Scom$Sgoogle$Sortools$Salgorithms$S*.cs
	-$(DEL) $(GEN_DIR)$Scom$Sgoogle$Sortools$Slinearsolver$S*.cs
	-$(DEL) $(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver$S*.cs
	-$(DEL) $(GEN_DIR)$Scom$Sgoogle$Sortools$Sknapsacksolver$S*.cs
	-$(DEL) $(GEN_DIR)$Scom$Sgoogle$Sortools$Sgraph$S*.cs
	-$(DEL) $(GEN_DIR)$Scom$Sgoogle$Sortools$Sflatzinc$S*.cs
	-$(DEL) $(GEN_DIR)$Scom$Sgoogle$Sortools$Sutil$S*.cs
	-$(DEL) $(OBJ_DIR)$Sswig$S*csharp_wrap.$O
	-$(DEL) $(BIN_DIR)$S*$(CLR_EXE_SUFFIX).exe
	-$(DEL) examples$Scsharp$SCsharp_examples.sln
	-$(DEL) examples$Scsharp$Ssolution$S*.csproj

# Assembly Info

$(GEN_DIR)/com/google/ortools/properties/GitVersion$(OR_TOOLS_VERSION).txt: $(GEN_DIR)/com/google/ortools/properties
	@echo $(OR_TOOLS_VERSION) > $(GEN_DIR)$Scom$Sgoogle$Sortools$Sproperties$SGitVersion$(OR_TOOLS_VERSION).txt

# See for background on Windows Explorer File Info Details:
#  https://social.msdn.microsoft.com/Forums/vstudio/en-US/27894a09-1eed-48d9-8a0f-2198388d492c/csc-modulelink-or-just-csc-dll-plus-some-external-dllobj-references
#  also, https://blogs.msdn.microsoft.com/texblog/2007/04/05/linking-native-c-into-c-applications/
$(GEN_DIR)/com/google/ortools/properties/CommonAssemblyInfo.cs: \
	$(GEN_DIR)/com/google/ortools/properties/GitVersion$(OR_TOOLS_VERSION).txt
	$(COPY) tools$Scsharp$SCommonAssemblyInfo.cs $(GEN_DIR)$Scom$Sgoogle$Sortools$Sproperties
	$(SED) -i -e "s/VVVV/$(OR_TOOLS_VERSION)\.\*/" $(GEN_DIR)$Scom$Sgoogle$Sortools$Sproperties$SCommonAssemblyInfo.cs
	$(SED) -i -e "s/XXXX/$(OR_TOOLS_VERSION)\.0/" $(GEN_DIR)$Scom$Sgoogle$Sortools$Sproperties$SCommonAssemblyInfo.cs

# TODO: TBD: it seems perhaps an AssemblyInfo build step is poised? why is it not being invoked?
$(GEN_DIR)/com/google/ortools/properties/AssemblyInfo.cs: \
	$(CLR_KEYFILE) \
	$(GEN_DIR)/com/google/ortools/properties/CommonAssemblyInfo.cs
	$(COPY) tools$Scsharp$SAssemblyInfo.cs $(GEN_DIR)$Scom$Sgoogle$Sortools$Sproperties
ifdef CLR_KEYFILE
ifeq ($(SYSTEM),win)
	@echo [assembly: AssemblyKeyFile("$(CLR_KEYFILE)")] >> $(GEN_DIR)$Scom$Sgoogle$Sortools$Sproperties$SAssemblyInfo.cs
else
	@echo "[assembly: AssemblyKeyFile(\"$(CLR_KEYFILE)\")]" >> $(GEN_DIR)$Scom$Sgoogle$Sortools$Sproperties$SAssemblyInfo.cs
endif
endif

# csharportools

csharportools: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(BIN_DIR)/$(CLR_PROTOBUF_DLL_NAME)$(DLL)

$(BIN_DIR)/$(CLR_PROTOBUF_DLL_NAME)$(DLL): tools/$(CLR_PROTOBUF_DLL_NAME)$(DLL)
	$(COPY) tools$S$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(BIN_DIR)

$(GEN_DIR)/linear_solver/linear_solver_csharp_wrap.cc: \
	$(SRC_DIR)/linear_solver/csharp/linear_solver.swig \
	$(SRC_DIR)/base/base.swig $(SRC_DIR)/util/csharp/proto.swig \
	$(LP_DEPS)
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -csharp -o $(GEN_DIR)$Slinear_solver$Slinear_solver_csharp_wrap.cc -module operations_research_linear_solver -namespace $(BASE_CLR_ORTOOLS_DLL_NAME).LinearSolver -dllimport "$(CLR_ORTOOLS_DLL_NAME).$(SWIG_LIB_SUFFIX)" -outdir $(GEN_DIR)$Scom$Sgoogle$Sortools$Slinearsolver $(SRC_DIR)/linear_solver$Scsharp$Slinear_solver.swig

$(OBJ_DIR)/swig/linear_solver_csharp_wrap.$O: $(GEN_DIR)/linear_solver/linear_solver_csharp_wrap.cc
	$(CCC) $(CFLAGS) -c $(GEN_DIR)/linear_solver/linear_solver_csharp_wrap.cc $(OBJ_OUT)$(OBJ_DIR)$Sswig$Slinear_solver_csharp_wrap.$O

$(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.cc: \
	$(SRC_DIR)/constraint_solver/csharp/routing.swig \
	$(SRC_DIR)/constraint_solver/csharp/constraint_solver.swig \
	$(SRC_DIR)/base/base.swig \
	$(SRC_DIR)/util/csharp/proto.swig \
	$(SRC_DIR)/util/csharp/functions.swig \
	$(CP_DEPS)
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -csharp -o $(GEN_DIR)$Sconstraint_solver$Sconstraint_solver_csharp_wrap.cc -module operations_research_constraint_solver -namespace $(BASE_CLR_ORTOOLS_DLL_NAME).ConstraintSolver -dllimport "$(CLR_ORTOOLS_DLL_NAME).$(SWIG_LIB_SUFFIX)" -outdir $(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver $(SRC_DIR)$Sconstraint_solver$Scsharp$Srouting.swig
	$(SED) -i -e 's/CSharp_new_Solver/CSharp_new_CpSolver/g' $(GEN_DIR)/com/google/ortools/constraintsolver/*cs $(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.*
	$(SED) -i -e 's/CSharp_delete_Solver/CSharp_delete_CpSolver/g' $(GEN_DIR)/com/google/ortools/constraintsolver/*cs $(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.*
	$(SED) -i -e 's/CSharp_Solver/CSharp_CpSolver/g' $(GEN_DIR)/com/google/ortools/constraintsolver/*cs $(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.*
	$(SED) -i -e 's/CSharp_new_Constraint/CSharp_new_CpConstraint/g' $(GEN_DIR)/com/google/ortools/constraintsolver/*cs $(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.*
	$(SED) -i -e 's/CSharp_delete_Constraint/CSharp_delete_CpConstraint/g' $(GEN_DIR)/com/google/ortools/constraintsolver/*cs $(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.*
	$(SED) -i -e 's/CSharp_Constraint/CSharp_CpConstraint/g' $(GEN_DIR)/com/google/ortools/constraintsolver/*cs $(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.*

$(OBJ_DIR)/swig/constraint_solver_csharp_wrap.$O: \
	$(GEN_DIR)/constraint_solver/constraint_solver_csharp_wrap.cc
	$(CCC) $(CFLAGS) -c $(GEN_DIR)$Sconstraint_solver$Sconstraint_solver_csharp_wrap.cc $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sconstraint_solver_csharp_wrap.$O

$(GEN_DIR)/algorithms/knapsack_solver_csharp_wrap.cc: \
	$(SRC_DIR)/algorithms/csharp/knapsack_solver.swig \
	$(SRC_DIR)/base/base.swig \
	$(SRC_DIR)/util/csharp/proto.swig \
	$(SRC_DIR)/algorithms/knapsack_solver.h
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -csharp -o $(GEN_DIR)$Salgorithms$Sknapsack_solver_csharp_wrap.cc -module operations_research_algorithms -namespace $(BASE_CLR_ORTOOLS_DLL_NAME).Algorithms -dllimport "$(CLR_ORTOOLS_DLL_NAME).$(SWIG_LIB_SUFFIX)" -outdir $(GEN_DIR)$Scom$Sgoogle$Sortools$Salgorithms $(SRC_DIR)$Salgorithms$Scsharp$Sknapsack_solver.swig

$(OBJ_DIR)/swig/knapsack_solver_csharp_wrap.$O: $(GEN_DIR)/algorithms/knapsack_solver_csharp_wrap.cc
	$(CCC) $(CFLAGS) -c $(GEN_DIR)/algorithms/knapsack_solver_csharp_wrap.cc $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sknapsack_solver_csharp_wrap.$O

$(GEN_DIR)/graph/graph_csharp_wrap.cc: \
	$(SRC_DIR)/graph/csharp/graph.swig \
	$(SRC_DIR)/base/base.swig \
	$(SRC_DIR)/util/csharp/proto.swig \
	$(GRAPH_DEPS)
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -csharp -o $(GEN_DIR)$Sgraph$Sgraph_csharp_wrap.cc -module operations_research_graph -namespace $(BASE_CLR_ORTOOLS_DLL_NAME).Graph -dllimport "$(CLR_ORTOOLS_DLL_NAME).$(SWIG_LIB_SUFFIX)" -outdir $(GEN_DIR)$Scom$Sgoogle$Sortools$Sgraph $(SRC_DIR)$Sgraph$Scsharp$Sgraph.swig

$(OBJ_DIR)/swig/graph_csharp_wrap.$O: $(GEN_DIR)/graph/graph_csharp_wrap.cc
	$(CCC) $(CFLAGS) -c $(GEN_DIR)$Sgraph$Sgraph_csharp_wrap.cc $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sgraph_csharp_wrap.$O

# Protobufs

$(GEN_DIR)/com/google/ortools/constraintsolver/SearchLimit.g.cs: $(SRC_DIR)/constraint_solver/search_limit.proto
	$(PROTOBUF_DIR)/bin/protoc --proto_path=$(SRC_DIR) --csharp_out=$(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver --csharp_opt=file_extension=.g.cs $(SRC_DIR)$Sconstraint_solver$Ssearch_limit.proto

$(GEN_DIR)/com/google/ortools/constraintsolver/SolverParameters.g.cs: $(SRC_DIR)/constraint_solver/solver_parameters.proto
	$(PROTOBUF_DIR)/bin/protoc --proto_path=$(SRC_DIR) --csharp_out=$(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver --csharp_opt=file_extension=.g.cs $(SRC_DIR)$Sconstraint_solver$Ssolver_parameters.proto

$(GEN_DIR)/com/google/ortools/constraintsolver/Model.g.cs: $(SRC_DIR)/constraint_solver/solver_parameters.proto
	$(PROTOBUF_DIR)/bin/protoc --proto_path=$(SRC_DIR) --csharp_out=$(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver --csharp_opt=file_extension=.g.cs $(SRC_DIR)$Sconstraint_solver$Smodel.proto

$(GEN_DIR)/com/google/ortools/constraintsolver/RoutingParameters.g.cs: $(SRC_DIR)/constraint_solver/routing_parameters.proto
	$(PROTOBUF_DIR)/bin/protoc --proto_path=$(SRC_DIR) --csharp_out=$(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver --csharp_opt=file_extension=.g.cs $(SRC_DIR)$Sconstraint_solver$Srouting_parameters.proto

$(GEN_DIR)/com/google/ortools/constraintsolver/RoutingEnums.g.cs: $(SRC_DIR)/constraint_solver/routing_enums.proto
	$(PROTOBUF_DIR)/bin/protoc --proto_path=$(SRC_DIR) --csharp_out=$(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver --csharp_opt=file_extension=.g.cs $(SRC_DIR)$Sconstraint_solver$Srouting_enums.proto

# Main DLL

$(CLR_KEYFILE):
ifdef CLR_KEYFILE
	sn -k $(CLR_KEYFILE)
endif

$(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL): \
	$(GEN_DIR)/com/google/ortools/properties/AssemblyInfo.cs \
	$(CLR_KEYFILE) \
	$(BIN_DIR)/$(CLR_PROTOBUF_DLL_NAME)$(DLL) \
	$(OBJ_DIR)/swig/linear_solver_csharp_wrap.$O \
	$(OBJ_DIR)/swig/constraint_solver_csharp_wrap.$O \
	$(OBJ_DIR)/swig/knapsack_solver_csharp_wrap.$O \
	$(OBJ_DIR)/swig/graph_csharp_wrap.$O \
	$(SRC_DIR)/com/google/ortools/algorithms/IntArrayHelper.cs \
	$(SRC_DIR)/com/google/ortools/constraintsolver/IntVarArrayHelper.cs \
	$(SRC_DIR)/com/google/ortools/constraintsolver/IntervalVarArrayHelper.cs \
	$(SRC_DIR)/com/google/ortools/constraintsolver/IntArrayHelper.cs \
	$(SRC_DIR)/com/google/ortools/constraintsolver/NetDecisionBuilder.cs \
	$(SRC_DIR)/com/google/ortools/constraintsolver/SolverHelper.cs \
	$(SRC_DIR)/com/google/ortools/constraintsolver/ValCstPair.cs \
	$(SRC_DIR)/com/google/ortools/linearsolver/DoubleArrayHelper.cs \
	$(SRC_DIR)/com/google/ortools/linearsolver/LinearExpr.cs \
	$(SRC_DIR)/com/google/ortools/linearsolver/LinearConstraint.cs \
	$(SRC_DIR)/com/google/ortools/linearsolver/SolverHelper.cs \
	$(SRC_DIR)/com/google/ortools/linearsolver/VariableHelper.cs \
	$(SRC_DIR)/com/google/ortools/util/NestedArrayHelper.cs \
	$(SRC_DIR)/com/google/ortools/util/ProtoHelper.cs \
	$(GEN_DIR)/com/google/ortools/constraintsolver/Model.g.cs\
	$(GEN_DIR)/com/google/ortools/constraintsolver/SearchLimit.g.cs\
	$(GEN_DIR)/com/google/ortools/constraintsolver/SolverParameters.g.cs\
	$(GEN_DIR)/com/google/ortools/constraintsolver/RoutingParameters.g.cs\
	$(GEN_DIR)/com/google/ortools/constraintsolver/RoutingEnums.g.cs\
	$(OR_TOOLS_LIBS)
ifeq ($(SYSTEM),win)
	$(CSC) /target:module /out:$(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME).netmodule /lib:$(BIN_DIR) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) /warn:0 /nologo /debug $(GEN_DIR)\\com\\google\\ortools\\linearsolver\\*.cs $(SRC_DIR)\\com\\google\\ortools\\linearsolver\\*.cs $(GEN_DIR)\\com\\google\\ortools\\constraintsolver\\*.cs $(SRC_DIR)\\com\\google\\ortools\\constraintsolver\\*.cs $(GEN_DIR)\\com\\google\\ortools\\algorithms\\*.cs $(SRC_DIR)\\com\\google\\ortools\\algorithms\\*.cs $(GEN_DIR)\\com\\google\\ortools\\graph\\*.cs $(SRC_DIR)\\com\\google\\ortools\\util\\*.cs $(GEN_DIR)\\com\\google\\ortools\\properties\\*.cs
	$(DYNAMIC_LD) $(SIGNING_FLAGS) $(LDOUT)$(BIN_DIR)$S$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME).netmodule $(OBJ_DIR)$Sswig$Slinear_solver_csharp_wrap.$O $(OBJ_DIR)$Sswig$Sconstraint_solver_csharp_wrap.$O $(OBJ_DIR)$Sswig$Sknapsack_solver_csharp_wrap.$O $(OBJ_DIR)$Sswig$Sgraph_csharp_wrap.$O $(OR_TOOLS_LNK) $(OR_TOOLS_LD_FLAGS)
else
	$(CSC) /target:library /out:$(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) /lib:$(BIN_DIR) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) /warn:0 /nologo /debug $(SRC_DIR)/com/google/ortools/util/*.cs $(GEN_DIR)/com/google/ortools/linearsolver/*.cs $(SRC_DIR)/com/google/ortools/linearsolver/*.cs $(GEN_DIR)/com/google/ortools/constraintsolver/*.cs $(SRC_DIR)/com/google/ortools/constraintsolver/*.cs $(SRC_DIR)/com/google/ortools/algorithms/*.cs $(GEN_DIR)/com/google/ortools/algorithms/*.cs $(GEN_DIR)/com/google/ortools/graph/*.cs $(GEN_DIR)/com/google/ortools/properties/*.cs
	$(DYNAMIC_LD) $(LDOUT)$(LIB_DIR)$S$(LIB_PREFIX)$(CLR_ORTOOLS_DLL_NAME).$(SWIG_LIB_SUFFIX) $(OBJ_DIR)/swig/linear_solver_csharp_wrap.$O $(OBJ_DIR)/swig/constraint_solver_csharp_wrap.$O $(OBJ_DIR)/swig/knapsack_solver_csharp_wrap.$O $(OBJ_DIR)/swig/graph_csharp_wrap.$O $(OR_TOOLS_LNK) $(OR_TOOLS_LD_FLAGS)
endif

# csharp linear solver examples

ifeq ($(EX),) # Those rules will be used if EX variable is not set

$(BIN_DIR)/cslinearprogramming$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/cslinearprogramming.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scslinearprogramming$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scslinearprogramming.cs

$(BIN_DIR)/csintegerprogramming$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/csintegerprogramming.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scsintegerprogramming$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scsintegerprogramming.cs

# csharp linear solver tests

$(BIN_DIR)/testlp$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/tests/testlp.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Stestlp$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /r:$(BIN_DIR)$S$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)$Stests$Stestlp.cs

testlp: $(BIN_DIR)/testlp$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Stestlp$(CLR_EXE_SUFFIX).exe

# csharp cp examples

$(BIN_DIR)/csrabbitspheasants$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/csrabbitspheasants.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scsrabbitspheasants$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scsrabbitspheasants.cs

$(BIN_DIR)/send_more_money$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/send_more_money.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Ssend_more_money$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Ssend_more_money.cs

$(BIN_DIR)/furniture_moving_intervals$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/furniture_moving_intervals.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Sfurniture_moving_intervals$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Sfurniture_moving_intervals.cs

$(BIN_DIR)/organize_day_intervals$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/organize_day_intervals.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Sorganize_day_intervals$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Sorganize_day_intervals.cs

$(BIN_DIR)/cstsp$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/cstsp.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scstsp$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scstsp.cs

$(BIN_DIR)/cscvrptw$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/cscvrptw.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scscvrptw$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scscvrptw.cs

$(BIN_DIR)/csls_api$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/csls_api.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scsls_api$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scsls_api.cs

# csharp constraint solver tests

$(BIN_DIR)/testcp$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/tests/testcp.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Stestcp$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Stests$Stestcp.cs

testcp: $(BIN_DIR)/testcp$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Stestcp$(CLR_EXE_SUFFIX).exe

$(BIN_DIR)/issue18$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/tests/issue18.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Sissue18$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Stests$Sissue18.cs

issue18: $(BIN_DIR)/issue18$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Sissue18$(CLR_EXE_SUFFIX).exe

$(BIN_DIR)/issue22$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/tests/issue22.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Sissue22$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Stests$Sissue22.cs

issue22: $(BIN_DIR)/issue22$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Sissue22$(CLR_EXE_SUFFIX).exe

$(BIN_DIR)/issue33$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/tests/issue33.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Sissue33$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Stests$Sissue33.cs

issue33: $(BIN_DIR)/issue33$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Sissue33$(CLR_EXE_SUFFIX).exe

$(BIN_DIR)/jobshop_bug$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/tests/jobshop_bug.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Sjobshop_bug$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Stests$Sjobshop_bug.cs

jobshop_bug: $(BIN_DIR)/jobshop_bug$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Sjobshop_bug$(CLR_EXE_SUFFIX).exe

# csharp algorithm examples

$(BIN_DIR)/csknapsack$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/csknapsack.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scsknapsack$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scsknapsack.cs

# csharp graph examples

$(BIN_DIR)/csflow$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/csflow.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scsflow$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Scsflow.cs

# Examples using multiple libraries.

$(BIN_DIR)/techtalk_scheduling$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX_DIR)/csharp/techtalk_scheduling.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Stechtalk_scheduling$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX_DIR)$Scsharp$Stechtalk_scheduling.cs

techtalk_scheduling: $(BIN_DIR)/techtalk_scheduling$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Stechtalk_scheduling$(CLR_EXE_SUFFIX).exe

else # This generic rule will be used if EX variable is set

$(BIN_DIR)$S$(basename $(notdir $(EX)))$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(EX)
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$S$(basename $(notdir $(EX)))$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:$(CLR_ORTOOLS_DLL_NAME)$(DLL) /r:$(CLR_PROTOBUF_DLL_NAME)$(DLL) $(EX)

csc: $(BIN_DIR)$S$(basename $(notdir $(EX)))$(CLR_EXE_SUFFIX).exe

rcs: $(BIN_DIR)$S$(basename $(notdir $(EX)))$(CLR_EXE_SUFFIX).exe
	@echo running $(BIN_DIR)$S$(basename $(notdir $(EX)))$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$S$(basename $(notdir $(EX)))$(CLR_EXE_SUFFIX).exe $(ARGS)

endif # ifeq ($(EX),)

# C# Fz support

csharpfz: \
	$(BIN_DIR)/Google.OrTools.Flatzinc$(DLL) \
	$(BIN_DIR)/csfz$(CLR_EXE_SUFFIX).exe

$(GEN_DIR)/flatzinc/flatzinc_csharp_wrap.cc: \
	$(SRC_DIR)/flatzinc/csharp/flatzinc.swig \
	$(SRC_DIR)/base/base.swig $(SRC_DIR)/util/csharp/proto.swig \
	$(FLATZINC_DEPS)
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -nodefaultctor -csharp -o $(GEN_DIR)$Sflatzinc$Sflatzinc_csharp_wrap.cc -module operations_research_flatzinc -namespace $(BASE_CLR_ORTOOLS_DLL_NAME).Flatzinc -dllimport "Google.OrTools.Flatzinc.$(SWIG_LIB_SUFFIX)" -outdir $(GEN_DIR)$Scom$Sgoogle$Sortools$Sflatzinc $(SRC_DIR)/flatzinc$Scsharp$Sflatzinc.swig

$(OBJ_DIR)/swig/flatzinc_csharp_wrap.$O: $(GEN_DIR)/flatzinc/flatzinc_csharp_wrap.cc
	$(CCC) $(CFLAGS) -c $(GEN_DIR)/flatzinc/flatzinc_csharp_wrap.cc $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sflatzinc_csharp_wrap.$O

$(BIN_DIR)/Google.OrTools.Flatzinc$(DLL): assembly_info \
	$(OBJ_DIR)/swig/flatzinc_csharp_wrap.$O \
	$(OR_TOOLS_LIBS) $(FLATZINC_LIBS)
ifeq ($(SYSTEM),win)
	$(CSC) /target:module /out:$(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc.netmodule /warn:0 /nologo /debug $(GEN_DIR)\\com\\google\\ortools\\flatzinc\\*.cs $(GEN_DIR)\\com\\google\\ortools\\properties\\*cs
	$(DYNAMIC_LD) $(SIGNING_FLAGS) $(LDOUT)$(BIN_DIR)$SGoogle.OrTools.Flatzinc$(DLL) $(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc.netmodule $(OBJ_DIR)$Sswig$Sflatzinc_csharp_wrap.$O $(FLATZINC_LNK) $(OR_TOOLS_LD_FLAGS)
else
	$(CSC) /target:library /out:$(BIN_DIR)/Google.OrTools.Flatzinc$(DLL) /warn:0 /nologo /debug $(GEN_DIR)/com/google/ortools/flatzinc/*.cs $(GEN_DIR)/com/google/ortools/properties/*cs
	$(DYNAMIC_LD) $(LDOUT)$(LIB_DIR)$S$(LIB_PREFIX)Google.OrTools.Flatzinc.$(SWIG_LIB_SUFFIX) $(OBJ_DIR)/swig/flatzinc_csharp_wrap.$O $(FLATZINC_LNK) $(OR_TOOLS_LD_FLAGS)
endif

$(BIN_DIR)/csfz$(CLR_EXE_SUFFIX).exe: $(BIN_DIR)/Google.OrTools.Flatzinc$(DLL) $(EX_DIR)/csharp/csfz.cs
	$(CSC) $(SIGNING_FLAGS) /target:exe /out:$(BIN_DIR)$Scsfz$(CLR_EXE_SUFFIX).exe /platform:$(NETPLATFORM) /lib:$(BIN_DIR) /r:Google.OrTools.Flatzinc$(DLL) $(EX_DIR)$Scsharp$Scsfz.cs

rcsfz: $(BIN_DIR)/csfz$(CLR_EXE_SUFFIX).exe
	$(MONO) $(BIN_DIR)$Scsfz$(CLR_EXE_SUFFIX).exe $(ARGS)


# Package output for NuGet distribution

clean_csharp_nuget:
ifeq ($(SYSTEM),win)
	if not exist temp $(MKDIR) temp
	if exist $(ORTOOLS_NUGET_DIR) $(ATTRIB) -r /s temp
	-$(RM_RECURSE_FORCED) $(ORTOOLS_NUGET_DIR)
endif

csharp_nuget_stage: \
	$(BIN_DIR)/$(CLR_ORTOOLS_DLL_NAME)$(DLL)
ifeq ($(SYSTEM),win)
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\$(BIN_DIR)
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\examples\solution\Properties
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\examples\data\discrete_tomography
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\examples\data\fill_a_pix
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\examples\data\minesweeper
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\examples\data\rogo
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\examples\data\survo_puzzle
	$(MKDIR_P) $(ORTOOLS_NUGET_DIR)\examples\data\quasigroup_completion
	$(COPY) LICENSE-2.0.txt $(ORTOOLS_NUGET_DIR)
	$(COPY) tools\README.dotnet $(ORTOOLS_NUGET_DIR)\README
	$(COPY) $(BIN_DIR)\$(CLR_ORTOOLS_DLL_NAME)$(DLL) $(ORTOOLS_NUGET_DIR)\$(BIN_DIR)
	$(COPY) $(BIN_DIR)\$(CLR_ORTOOLS_DLL_NAME)$(PDB) $(ORTOOLS_NUGET_DIR)\$(BIN_DIR)
	$(COPY) $(BIN_DIR)\$(CLR_ORTOOLS_DLL_NAME)$(L) $(ORTOOLS_NUGET_DIR)\$(BIN_DIR)
	$(COPY) $(BIN_DIR)\$(CLR_ORTOOLS_DLL_NAME)$(EXP) $(ORTOOLS_NUGET_DIR)\$(BIN_DIR)
	$(COPY) examples\csharp\*.cs $(ORTOOLS_NUGET_DIR)\examples
	$(COPY) examples\csharp\*.sln $(ORTOOLS_NUGET_DIR)\examples
	$(COPY) examples\csharp\solution\*.csproj $(ORTOOLS_NUGET_DIR)\examples\solution
	$(COPY) examples\csharp\solution\Properties\*.cs $(ORTOOLS_NUGET_DIR)\examples\solution\Properties
	$(COPY) examples\data\discrete_tomography\* $(ORTOOLS_NUGET_DIR)\examples\data\discrete_tomography
	$(COPY) examples\data\fill_a_pix\* $(ORTOOLS_NUGET_DIR)\examples\data\fill_a_pix
	$(COPY) examples\data\minesweeper\* $(ORTOOLS_NUGET_DIR)\examples\data\minesweeper
	$(COPY) examples\data\rogo\* $(ORTOOLS_NUGET_DIR)\examples\data\rogo
	$(COPY) examples\data\survo_puzzle\* $(ORTOOLS_NUGET_DIR)\examples\data\survo_puzzle
	$(COPY) examples\data\quasigroup_completion\* $(ORTOOLS_NUGET_DIR)\examples\data\quasigroup_completion
endif

tools\$(ORTOOLS_NUSPEC_NAME): csharp_nuget_stage
ifeq ($(SYSTEM),win)
	$(COPY) tools\$(ORTOOLS_NUSPEC_NAME) $(ORTOOLS_NUGET_DIR)
	$(SED) -i -e "s/NNNN/$(CLR_ORTOOLS_DLL_NAME)/" $(ORTOOLS_NUGET_DIR)\$(ORTOOLS_NUSPEC_NAME)
	$(SED) -i -e "s/MMMM/$(CLR_PROTOBUF_DLL_NAME)/" $(ORTOOLS_NUGET_DIR)\$(ORTOOLS_NUSPEC_NAME)
	$(SED) -i -e "s/VVVV/$(OR_TOOLS_VERSION)/" $(ORTOOLS_NUGET_DIR)\$(ORTOOLS_NUSPEC_NAME)
	$(SED) -i -e "s/PROTOBUF_TAG/$(PROTOBUF_TAG)/" $(ORTOOLS_NUGET_DIR)\$(ORTOOLS_NUSPEC_NAME)
endif

csharp_nuget_pack: \
	tools\$(ORTOOLS_NUSPEC_NAME)
ifeq ($(SYSTEM),win)
	$(CD) $(ORTOOLS_NUGET_DIR) && $(NUGET_PACK) $(ORTOOLS_NUSPEC_NAME)
endif

$(CLR_ORTOOLS_DLL_NAME).$(OR_TOOLS_VERSION).nupkg: csharp_nuget_pack

csharp_nuget_push: \
	$(CLR_ORTOOLS_DLL_NAME).$(OR_TOOLS_VERSION).nupkg
	$(CD) $(ORTOOLS_NUGET_DIR) && $(NUGET_PUSH) $(CLR_ORTOOLS_DLL_NAME).$(OR_TOOLS_VERSION).nupkg -Source $(NUGET_SRC)

# Target for backwards makefile compatibility.
nuget_upload: csharp_nuget_push

# TODO: TBD: add FlatZinc nuget targets

# csharpsolution
# create solution files for visual studio

ifeq ($(SYSTEM),win)
csharpsolution: examples/csharp/Csharp_examples.sln
else
csharpsolution:
endif

examples/csharp/solution/%.csproj: examples/csharp/%.cs tools/template.csproj
	$(COPY) tools$Stemplate.csproj examples$Scsharp$Ssolution$S$(@F)
# Replace all "SOURCEFILE" instances with the C# example source file
# AND
# Replace all "EXECUTABLE" instances with the name of the executable. the first letter is capitalized.
	$(SED) -i -e "s/SOURCEFILE/$*.cs/" -e "s/EXECUTABLE/\u$*/" examples$Scsharp$Ssolution$S$(@F)

ALL_CSPROJ= $(patsubst examples/csharp/%.cs, examples/csharp/solution/%.csproj, $(wildcard examples/csharp/*.cs))

examples/csharp/Csharp_examples.sln: tools/template.sln $(ALL_CSPROJ)
	-$(DEL) examples$Scsharp$SCsharp_examples.sln
	$(COPY) tools$Stemplate.sln examples$Scsharp$SCsharp_examples.sln
#Add the *csproj files to the solution
	$(SED) -i '/#End Projects/i $(join \
	$(patsubst examples/csharp/solution/%.csproj, Project\(\"{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}\"\)=\"%\"$(COMMA) , $(wildcard examples/csharp/solution/*.csproj)), \
$(patsubst examples/csharp/solution/%.csproj, \"solution%.csproj\"$(COMMA)\"{}\"EndProject, $(wildcard examples/csharp/solution/*.csproj)) \
)' examples/csharp/Csharp_examples.sln
	$(SED) -i -e "s/solution/solution\\/g" -e "s/EndProject/\r\nEndProject\r\n/g" -e "s/ Project/Project/g" examples$Scsharp$SCsharp_examples.sln
