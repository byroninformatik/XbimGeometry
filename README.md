# Fork of  xBimTeam / XbimGeometry 

all further information see https://github.com/xBimTeam/XbimGeometry

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
   Zeile 497 class `CreateContextOptions`
```csharp
        /// <summary>
        /// RHE 04.09.2025 - options that are used when calculating the geometry in Xbim3DModelContext.CreateContext
        /// </summary>
        public class CreateContextOptions {
            /// <summary>
            /// This callback is used before openings are cut into the entity specified by the parameter
            /// </summary>
            public Func<IPersistEntity, bool> CutOpenings { get; set; } = (_) => true;
        }
```
9. Änderungen in `Xbim.ModelGeometry.Scene/Xbim3DModelContext.cs` wieder vornehmen  
   Zeile 747  property `ContextOptions`
```csharp
        /// <summary>
        /// RHE 04.09.2025 - these options are used when calculating the geometry in CreateContext
        /// </summary>
        public CreateContextOptions ContextOptions { get; private set; } = new CreateContextOptions();
```
10. Änderungen in `Xbim.ModelGeometry.Scene/Xbim3DModelContext.cs` wieder vornehmen  
    Zeile 1052 Verwendung von ContextOptions
```csharp
                        // RHE 04.09.2025 - ContextOptions verwendet
                        var entity = _model.Instances[elementLabel];
                        if (this.ContextOptions.CutOpenings(entity)) 
                        {
```
11. Änderungen in `Xbim.ModelGeometry.Scene/Xbim3DModelContext.cs` wieder vornehmen  
    Zeile 1094 Verwendung von ContextOptions
```csharp
                        }
                        else // RHE 22.11.2022 - ContextOptions verwendet
                        { 
                            LogInfo(entity, "Cutting openings was omitted");
                        }
```
12. Änderungen in `Xbim.ModelGeometry.Scene/Xbim3DModelContext.cs` wieder vornehmen  
    diverse Debug-Statements erneut entfernen. Suche in der bestehenden Version nach `RHE 04.09.2025` 
13. Sicherstellen, dass das Testprojekt in [intern-XbimExtensions](https://github.com/byroninformatik/intern-XbimExtensions) mit dem eigenen Package bzw. den eigenen Projekten läuft.
14. Neue Versionsnummern vergeben für die generierten nuget Pakete. Die Revisionsversion der Byron-Pakete beginnt jeweils bei 900. Beispiel: 6.1.801.900
	- in `Directory.Build.props`
15. Publizieren und Testen 