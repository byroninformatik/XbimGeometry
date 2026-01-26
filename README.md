# Fork of  xBimTeam / XbimGeometry 

all further information see https://github.com/xBimTeam/XbimGeometry  
and [issue #552](https://github.com/xBimTeam/XbimGeometry/issues/552)  

# Informationen zum Fork
Ziel dieses Package ist es, dass Xbim.Geometry in .NET Core Projekten ohne Warnungen verwendet werden kann.
Es wird hier nur der einfache Fall des Aktualisierens beschrieben (neue C# oder C++ Sourcen).
Bei einer Veränderung der Projektstruktur müssen die Projektdateien neu aufgesetzt werden.

## Voraussetzungen
- Visual Studio 2022 _Desktopentwicklung mit C++_ (v143) installiert


1. Den Fork aktualisieren
    - den richtigen Branch als Startpunkt auswählen (z.B. _6.1.801_ auf Basis des Beispiels [CreateWexBIM](https://github.com/xBimTeam/XbimSamples/blob/master/CreateWexBIM/CreateWexBIM.csproj))
	- einen eigenen Branch erzeugen (z.B. _byron/develop_) oder einen bestehenden Byron-Branch rebasen
2. Sicherstellen, dass sich die Projektmappe kompilieren lässt
    - C++ Projekt
    - C# Projekte (nur Xbim.ModelGeometry.Scene und Xbim.Geometry.Engine.Interop)
3. Sicherstellen, dass die Testcases grün sind.
4. In den Projektdateien `Xbim.Geometry.Engine.Interop.csproj` und `Xbim.ModelGeometry.Scene.csproj` sicherstellen, dass ein .NET core Target Framework vorhanden ist
5. Änderungen in `Xbim.ModelGeometry.Scene/Xbim3DModelContext.cs` wieder vornehmen  
Zeile 926 bis 975
```csharp
                try {
                    ...
                        var boolOp = new XbimProductBooleanInfo(this, contextHelper, Engine, Model, shapeIdsUsedMoreThanOnce, productShapes, cutTools, projectTools, context, styleId);
                        openingAndProjectionOps.Add(boolOp);
                    }
                } catch {
                    _logger.LogError("Intercepted exception calculating geometry of {entity}", element);
                    throw;
                }
```
5. Änderungen in `Xbim.ModelGeometry.Scene/Xbim3DModelContext.cs` wieder vornehmen  
    diverse Debug-Statements erneut entfernen. Suche in der bestehenden Version nach `RHE 04.09.2025` 
6. Korrekturen in der Xbim.Geometry.Engine - vgl. [Issue #552](https://github.com/xBimTeam/XbimGeometry/issues/552)  
Änderungen in `Xbim.Geometry.Engine/Factories/GeometryFactory.cpp` wieder vornehmen  
Zeile 110
```cpp
			bool GeometryFactory::BuildPoint2d(IIfcCartesianPoint^ ifcPoint, gp_Pnt2d& pnt2d)
			{

				if ((int)ifcPoint->Dim > 1) // RHE 17.09.2025 - fix "== 2" => "> 1"
				{
					pnt2d.SetXY(gp_XY(ifcPoint->Coordinates[0], ifcPoint->Coordinates[1]));
					return true;
				}
				else
					return false;
			}
```
Zeile 127
```cpp
			bool GeometryFactory::BuildDirection2d(IIfcDirection^ ifcDir, gp_Vec2d& dir2d)
			{
				if ((int)ifcDir->Dim < 2) return false; // RHE 17.09.2025 - fix "!= 2" => "< 2"
				return EXEC_NATIVE->BuildDirection2d(ifcDir->DirectionRatios[0], ifcDir->DirectionRatios[1], dir2d);
			}

```
7. Alle Vorkommen von `std::mutex` durch `std::shared_mutex` ersetzen. Dies sind aktuell die Dateien
    - _Cache.h_
    - _WireFactory.h_
8. Sicherstellen, dass das Testprojekt in [intern-XbimExtensions](https://github.com/byroninformatik/intern-XbimExtensions) mit dem eigenen Package bzw. den eigenen Projekten läuft.
9. Neue Versionsnummern vergeben für die generierten nuget Pakete. Die Revisionsversion der Byron-Pakete beginnt jeweils bei 900. Beispiel: 6.1.801.900
	- in `Directory.Build.props`
10. Publizieren und Testen 