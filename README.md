# UImGui

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/psydack/uimgui?style=flat-square)  

UImGui (Unity ImGui) is an UPM package for the immediate mode GUI library using [ImGui.NET](https://github.com/mellinoe/ImGui.NET).

This a fork of [UImGui](https://github.com/psydack/uimgui), which that project is based on [RG.ImGui](https://github.com/realgamessoftware/dear-imgui-unity) project.
This project use [FreeType](https://github.com/ocornut/imgui/tree/master/misc/freetype) as default the renderer.

**Using ImGui 1.84 WIP**

## What is Dear ImGui?

> Dear ImGui is a **bloat-free graphical user interface library for C++**. It outputs optimized vertex buffers that you can render anytime in your 3D-pipeline enabled application. It is fast, portable, renderer agnostic and self-contained (no external dependencies).
> 
> Dear ImGui is designed to **enable fast iterations** and to **empower programmers** to create **content creation tools and visualization / debug tools** (as opposed to UI for the average end-user). It favors simplicity and productivity toward this goal, and lacks certain features normally found in more high-level libraries.

## Motivation

To update (using ImGui.Net.dll) easier and often.

## Features

| Feature                                     |         RG         |      UImGui                                    |
| ------------------------------------------- | ------------------ | ---------------------------------------------- |
| IL2CPP                                      | :x:                | :heavy_check_mark:                             |
| Windows                                     | :heavy_check_mark: | :heavy_check_mark:                             |
| Linux                                       | :heavy_check_mark: | :heavy_check_mark: (Needs Freetype2 Installed) |
| MacOS                                       | :heavy_check_mark: | :x:                                            |
| Custom Assert                               | :heavy_check_mark: | :x:                                            |
| Unity Input Manager                         | :heavy_check_mark: | :heavy_check_mark:                             |
| Unity Input System                          | :heavy_check_mark: | :heavy_check_mark:                             |
| Docking                                     | :x:                | :heavy_check_mark:                             |
| RenderPipeline Built in                     | :heavy_check_mark: | :heavy_check_mark:                             |
| RenderPipeline URP                          | :x:                | :heavy_check_mark:                             |
| RenderPipeline HDRP                         | :x:                | :heavy_check_mark:                             |
| Renderer Mesh                               | :heavy_check_mark: | :heavy_check_mark:                             |
| Renderer Procedural                         |          ~         | :heavy_check_mark:                             |
| FreeType                                    |          ~         | :heavy_check_mark:                             |
| Image / Texture                             | :x:                | :heavy_check_mark:                             |

## Usage

1. [Add package](https://docs.unity3d.com/Manual/upm-ui-giturl.html) from git URL: `https://github.com/Voltstro-Studios/uimgui.git`
2. Add `UImGui` component to the scene and
3. (Optional) Set `Platform Type` to `Input System` if you're using the new [input system](https://docs.unity3d.com/Packages/com.unity.inputsystem@1.0/manual/index.html) the `SampleDemoWindow` object on the scene the following properties:
4. You're ready. Look at the [Example section](#examples) for more usage samples.  

### Using URP

- Add a `Render Im Gui Feature` render feature to the renderer asset.
- Assign it to the `render feature` field of the DearImGui component.
- Check this [issue](https://github.com/psydack/uimgui/issues/14) which I describe how to make it work step by step.

### Using HDRP

When using the `High Definition Render Pipeline`:

- Add a script called Custom Pass Volume anywhere on your scene;
- Add "DearImGuiPass"
- Update Injection Point to before or after post processing.
- Good to go.

Any doubts [see this link](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@7.1/manual/Custom-Pass.html)

## Examples

You can subscribe to global layout or for a specific `UImGui` context:
If choose to use global, don't to forget to set `Do Global Events` to `true` on `UImGui` instance.

### Basic

```cs
using UImGui;
using ImGuiNET;
using UnityEngine;

public class StaticSample : MonoBehaviour
{
	private void Awake()
	{
		UImGuiUtility.Layout += OnLayout;
	}

	private void OnLayout(UImGui.UImGui obj)
	{
		// Unity Update method. 
		// Your code belongs here! Like ImGui.Begin... etc.
		ImGui.ShowDemoWindow();
	}

	private void OnInitialize(UImGui.UImGui obj)
	{
		// runs after UImGui.OnEnable();
	}

	private void OnDeinitialize(UImGui.UImGui obj)
	{
		// runs after UImGui.OnDisable();
	}

	private void OnDisable()
	{
		UImGuiUtility.Layout -= OnLayout;
		UImGuiUtility.OnInitialize -= OnInitialize;
		UImGuiUtility.OnDeinitialize -= OnDeinitialize;
	}
}

```

### Simple Example

```cs
[SerializeField]
private float sliderFloatValue = 1;

[SerializeField]
private string inputText;

// Add listeners, etc ...

private void OnLayout(UImGui.UImGui obj)
{
	ImGui.Text($"Hello, world {123}");
	if (ImGui.Button("Save"))
	{
		Debug.Log("Save");
	}

	ImGui.InputText("string", ref inputText, 100);
	ImGui.SliderFloat("float", ref sliderFloatValue, 0.0f, 1.0f);
}
```
![Image](https://user-images.githubusercontent.com/961971/119239324-b54bf880-bb1e-11eb-87e3-0ecbfaafde27.png)

### More Complex Example

```cs
[SerializeField] private Vector4 myColor;
private bool isOpen;

private void OnLayout(UImGui.UImGui obj)
{
	// Create a window called "My First Tool", with a menu bar.
	ImGui.Begin("My First Tool", ref isOpen, ImGuiWindowFlags.MenuBar);
	if (ImGui.BeginMenuBar())
	{
		if (ImGui.BeginMenu("File"))
		{
			if (ImGui.MenuItem("Open..", "Ctrl+O")) 
			{
				/* Do stuff */
			}
			if (ImGui.MenuItem("Save", "Ctrl+S")) 
			{
				/* Do stuff */
			}
			if (ImGui.MenuItem("Close", "Ctrl+W")) 
			{
				isOpen = false; 
			}
			ImGui.EndMenu();
		}
		ImGui.EndMenuBar();
	}

	// Edit a color (stored as ~4 floats)
	ImGui.ColorEdit4("Color", ref myColor);

	// Plot some values
	float[] myValues = new float[] { 0.2f, 0.1f, 1.0f, 0.5f, 0.9f, 2.2f };
	ImGui.PlotLines("Frame Times", ref myValues[0], myValues.Length);


	// Display contents in a scrolling region
	ImGui.TextColored(new Vector4(1, 1, 0, 1), "Important Stuff");
	ImGui.BeginChild("Scrolling");
	for (int n = 0; n < 50; n++)
		ImGui.Text($"{n}: Some text");
	ImGui.EndChild();
	ImGui.End();
}
```
![Image](https://user-images.githubusercontent.com/961971/119239823-f42f7d80-bb21-11eb-9f65-9fe03d8b2887.png)

### Image Example

```cs
[SerializeField]
private Texture sampleTexture;

private void OnLayout(UImGui.UImGui obj)
{
	if (ImGui.Begin("Image Sample"))
	{
		System.IntPtr id = UImGuiUtility.GetTextureId(sampleTexture);
		Vector2 size = new Vector2(sampleTexture.width, sampleTexture.height)
		ImGui.Image(id, size);

		ImGui.End();
	}
}
```
![Image](https://user-images.githubusercontent.com/961971/119574206-b9308280-bd8b-11eb-9df2-8bc07cf57140.png)  
  
### Custom UserData Example

```cs
[Serializable]
private struct UserData
{
	public int SomeCoolValue;
}

[SerializeField]
private UserData _userData;
private string _input = "";

// Add Listeners... etc.

private unsafe void OnInitialize(UImGui.UImGui uimgui)
{
	fixed (UserData* ptr = &_userData)
	{
		uimgui.SetUserData((IntPtr)ptr);
	}
}

private unsafe void OnLayout(UImGui.UImGui obj)
{
	if (ImGui.Begin("Custom UserData"))
	{
		fixed (UserData* ptr = &_userData)
		{
			ImGuiInputTextCallback customCallback = CustomCallback;
			ImGui.InputText("label", ref _input, 100, ~(ImGuiInputTextFlags)0, customCallback, (IntPtr)ptr);
		}

		ImGui.End();
	}
}

private unsafe int CustomCallback(ImGuiInputTextCallbackData* data)
{
	IntPtr userDataPtr = (IntPtr)data->UserData;
	if (userDataPtr != IntPtr.Zero)
	{
		UserData userData = Marshal.PtrToStructure<UserData>(userDataPtr);
		Debug.Log(userData.SomeCoolValue);
	}

	// You must to overwrite how you handle with new inputs.
	// ...

	return 1;
}
```
![Image](https://user-images.githubusercontent.com/961971/120383734-a1ad4880-c2fb-11eb-87e1-398d5e7aac97.png)

## Custom Font

[Thanks](https://github.com/psydack/uimgui/pull/24)  
[Check here for more information](https://github.com/ocornut/imgui/blob/master/docs/FONTS.md)

First create a method with ImGuiIOPtr like this

```cs
public void AddJapaneseFont(ImGuiIOPtr io)
{
	// you can put on StreamingAssetsFolder and call from there like:
	//string fontPath = $"{Application.streamingAssetsPath}/NotoSansCJKjp - Medium.otf";
	string fontPath = "D:\\Users\\rofli.souza\\Desktop\\NotoSansCJKjp-Medium.otf";
	io.Fonts.AddFontFromFileTTF(fontPath, 18, null, io.Fonts.GetGlyphRangesJapanese());

	// you can create a configs and do a lot of stuffs
	//ImFontConfig fontConfig = default;
	//ImFontConfigPtr fontConfigPtr = new ImFontConfigPtr(&fontConfig);
	//fontConfigPtr.MergeMode = true;
	//io.Fonts.AddFontDefault(fontConfigPtr);
	//int[] icons = { 0xf000, 0xf3ff, 0 };
	//fixed (void* iconsPtr = icons)
	//{
	//	io.Fonts.AddFontFromFileTTF("fontawesome-webfont.ttf", 18.0f, fontConfigPtr, (System.IntPtr)iconsPtr);
	//}
}
```  

Assign the object that contain these method in UImGui script

![image](https://user-images.githubusercontent.com/961971/149441417-54b319c8-30e7-40dd-aa56-edaede47543d.png)

Create an awesome text:

```cs
if (ImGui.Begin("ウィンドウテスト"))
{
	ImGui.Text("こんにちは！テスト");

	ImGui.End();
}
```

![image](https://user-images.githubusercontent.com/961971/149443777-38f439f5-5aca-4188-a21b-32274e901382.png)  

Yay!
  
You can [see more samples here](https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html).

## Authors

- **realgamessoftware** - Initial work of [RG.ImGui](https://github.com/realgamessoftware/dear-imgui-unity) - [realgamessoftware](https://github.com/realgamessoftware)
- **psydack** - Initial work - [psydack](https://github.com/psydack)
- **Voltstro** - This fork's maintainer - [Voltstro](https://github.com/Voltstro)

## License

This project is licensed under the MIT License - see the [LICENSE.md](/LICENSE.md) file for details.
