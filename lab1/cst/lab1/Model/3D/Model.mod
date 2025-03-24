'# MWS Version: Version 2018.0 - Oct 26 2017 - ACIS 27.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 8.2 fmax = 12.4
'# created = '[VERSION]2018.0|27.0.2|20171026[/VERSION]


'@ use template: Antenna - Waveguide.cfg

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Mesh.FPBAAvoidNonRegUnite "True"
Mesh.ConsiderSpaceForLowerMeshLimit "False"
Mesh.MinimumStepNumber "5"

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")



'@ new component: component1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Component.New "component1" 


'@ define brick: component1:brick1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Brick
     .Reset 
     .Name "brick1" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-(a+t)/2", "(a+t)/2" 
     .Yrange "-(b+t)/2", "(b+t)/2" 
     .Zrange "-Lambda/2", "0" 
     .Create
End With


'@ define curve rectangle: curve1:rectangle1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Rectangle
     .Reset 
     .Name "rectangle1" 
     .Curve "curve1" 
     .Xrange "-(DH+t)", "(DH+t)" 
     .Yrange "-(DE+t)", "(DE+t)" 
     .Create
End With


'@ define coverprofile: component1:solid1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "PEC" 
     .Curve "curve1:rectangle1" 
     .DeleteCurve "True" 
     .Create
End With


'@ transform: translate component1:solid1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Vector "0", "0", "L" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With 


'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:solid1", "1" 


'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:brick1", "1" 


'@ define loft: component1:solid2

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Loft 
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "PEC" 
     .Tangency "0.0" 
     .Minimizetwist "true" 
     .CreateNew 
End With 


'@ boolean add shapes: component1:brick1, component1:solid1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Add "component1:brick1", "component1:solid1" 


'@ boolean add shapes: component1:brick1, component1:solid2

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.Add "component1:brick1", "component1:solid2" 


'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:brick1", "7" 


'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:brick1", "9" 


'@ shell object: component1:brick1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solid.ShellAdvanced "component1:brick1", "Inside", "t", "True" 


'@ define frequency range

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Solver.FrequencyRange "8.2", "12.4" 


'@ define background

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Background 
     .ResetBackground 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0.0" 
     .ApplyInAllDirections "False" 
End With 

With Material 
     .Reset 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .HeatCapacity "0"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "m"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "1.0"
     .Mu "1.0"
     .Sigma "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMu "False"
     .ConstTanDModelOrderMu "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NonlinearMeasurementError "1e-1"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.6", "0.6", "0.6" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeBackgroundMaterial
End With 


'@ pick face

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Pick.PickFaceFromId "component1:brick1", "9" 


'@ define port: 1

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label "" 
     .Folder "" 
     .NumberOfModes "5" 
     .AdjustPolarization "False" 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .TextMaxLimit "0" 
     .Coordinates "Picks" 
     .Orientation "positive" 
     .PortOnBound "False" 
     .ClipPickedPortToBound "False" 
     .Xrange "-11.93", "11.93" 
     .Yrange "-5.58", "5.58" 
     .Zrange "-14.55", "-14.55" 
     .XrangeAdd "0.0", "0.0" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "0.0", "0.0" 
     .SingleEnded "False" 
     .WaveguideMonitor "False" 
     .Create 
End With 


'@ define farfield monitor: farfield (f=10.3)

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=10.3)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "10.3" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-81", "81", "-39", "39", "-14.55", "80" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .Create 
End With 


'@ define time domain solver parameters

'[VERSION]2018.0|27.0.2|20171026[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "1"
     .StimulationMode "1"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With


