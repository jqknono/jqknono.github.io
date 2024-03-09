# UWP入门

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [1.1. XAML 简介](#11-xaml-简介)
- [1.2. 最基础的控件(Control) -- TextBlock, Button](#12-最基础的控件control----textblock-button)
- [3.1. ViewModel 操控 Model 的数据](#31-viewmodel-操控-model-的数据)
- [3.2. Model 通知 ViewModel -- event](#32-model-通知-viewmodel----event)
- [4.1. 数据绑定](#41-数据绑定)
  - [4.1.1. 绑定在 ViewModel](#411-绑定在-viewmodel)
  - [4.1.2. 绑定在其它 Control](#412-绑定在其它-control)
  - [4.1.3. 指定 DataContext](#413-指定-datacontext)
- [7.1. DataTemplate](#71-datatemplate)
- [7.2. UserControl](#72-usercontrol)
  - [7.2.1. DependencyProperty](#721-dependencyproperty)
- [9.1. 在 Control 里定制 Style](#91-在-control-里定制-style)
- [9.2. 使用统一的 Style -- ResourceDictionary](#92-使用统一的-style----resourcedictionary)
- [9.3. 使用 ThemeResource](#93-使用-themeresource)
- [10.1. Grid](#101-grid)
- [10.2. StackPanel](#102-stackpanel)

<!-- /TOC -->

# 1. Xaml

## 1.1. XAML 简介

* [XAML 概述](https://docs.microsoft.com/zh-cn/windows/uwp/xaml-platform/xaml-overview)
* 主要用于创建可视的 UI 元素.
* Xaml 的基本语法基于 XML.
* 声明一个 namespace 的别名:

```xml
xmlns:controls="using:Common.Controls"
```

* 使用 namespace 中声明的类:

```xml
<mycontrol></mycontrol>
```

* 可重用的资源(Resource),

**x:Key**

```xml

<style x:key="TextBlock_Style"></style>

```

* 控件元素的 Name,

x:Name

Xaml:

```xml
<mycontrol x:name="myControl"></mycontrol>
```

C#:

```csharp
private MyControl myControl;
```

* 本地化

**x:Uid**

```xml
<textblock x:uid="sampleText"></textblock>
```

## 1.2. 最基础的控件(Control) -- TextBlock, Button

```xml
<page x:class="MyPage" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"><stackpanel>
<textblock text="UWP Introduction"></textblock>
<button content="UWP Introduction" click="Button_Click"></button>
</stackpanel>
</page>```

# 2. MVVM

[MVVM 详细介绍](https://msdn.microsoft.com/en-us/library/hh848246.aspx)

![View &lt;=&gt; ViewModel &lt;=&gt; Model](/img/IC564167.png)

* View 尽量只包含 UI 展示的内容, View 大部分使用 Xaml 语言完成;
* ViewModel 应尽量不包含业务处理逻辑, 而是通过调用 Model 里的函数完成动作;
* Model 应尽量包含所有的业务数据和逻辑, 并尽量不依赖 View 和 ViewModel;

# 3. ViewModel 与 Model 的交互

## 3.1. ViewModel 操控 Model 的数据

**ViewModel:**

```csharp
public class ViewModel
{
private Model model;
private ChangeA()
{
this.model.A = "A";
}
}
```

**Model:**

```csharp
public class Model
{
public string A { get; set; }
public string B { get; set; }
}
```

## 3.2. Model 通知 ViewModel -- event

**ViewModel:**

```csharp
public class ViewModel
{
private Model model;
private ChangeA()
{
r.BEventArgs += this.Handler;
}
private void Handler(object sender, EventArgs e)
{
AnyActions();
}
}
```

**Model:**

```csharp
public delegate void BChangedHandler(object sender, EventArgs e);

public class Model
{
public string A { get; set; }
private string _B;
public string B
{
get { return this._B; }
set
{
this._B = value;
if (BEventArgs != null)
{
BEventArgs(this, new EventArgs());
}
}
}
public event BChangedHandler BEventArgs;
}
```

# 4. View 与 ViewModel 的交互

## 4.1. 数据绑定

* [数据绑定概述](https://docs.microsoft.com/zh-cn/windows/uwp/data-binding/)
* 只有 [DependencyProperty](https://docs.microsoft.com/en-us/dotnet/framework/wpf/advanced/dependency-properties-overview) 可以被绑定
* 绑定在 Public 的 Property
* 谨慎重构

### 4.1.1. 绑定在 ViewModel

**View:**

```xml
<textblock text="{Binding" sampletext></textblock>
```

**ViewModel:**

```csharp
public string SampleText { get; set; }
```

### 4.1.2. 绑定在其它 Control

**View:**

```xml
<textblock x:name="TextBlock1" text="SampleText"></textblock>
<button content="{Binding ElementName=TextBlock1, Path= Text}"></button>
```

### 4.1.3. 指定 DataContext

```csharp
public ViewModelClass ViewModel { get; set; }

...
SpecifiedControl.DataContext = ViewModel;
...
```

# 5. (View 与 ViewModel) 实现消息通知 -- INotifyPropertyChanged

当 SampleText 发生变化时, 会通知到绑定在该 property 的 DependencyProperty

```csharp
public class MyControlViewModel : INotifyPropertyChanged
{
public event PropertyChangedEventHandler PropertyChanged;

public void Notify(string propName)
{
if (this.PropertyChanged != null)
{
PropertyChanged(this, new PropertyChangedEventArgs(propName));
}
}

private string _sampleText;
public string SampleText
{
get
{
return _sampleText;
}
set
{
_sampleText = value;
Notify(nameof(SampleText));
}
}
}
```

或者继承 ViewModelBase

```csharp
public class ViewModelBase : INotifyPropertyChanged
{
public event PropertyChangedEventHandler PropertyChanged;

public void Notify(string propName)
{
if (this.PropertyChanged != null)
{
PropertyChanged(this, new PropertyChangedEventArgs(propName));
}
}
}
```

# 6. (View 与 ViewModel) ListView 绑定到实现了消息通知的源 -- ObservableCollection

![ListView](/img/ListView.png)

在 ListView 中实现绑定到具有消息通知的 ItemSource

**View:**

```xml
 	<listview itemssource="{Binding Items}">
```</listview>

**ViewModel:**

```csharp
public ObservableCollection<recording> Items { get; set; }</recording>

```

* ObservableCollection 只在 Item 添加\移除, 整个列表刷新时才产生消息通知;
* 如果需要在 item Recording 的内容发生变化时通知界面, 需要由 Recording 实现 **INotifyPropertyChanged**.

# 7. (View) ListView 的 Item 模板(DataTemplate | UserControl)

## 7.1. DataTemplate

**View:**

```xml
 	<listview itemssource="{Binding Items}"> 	<listview.itemtemplate><datatemplate datatype="local:Recording">
<stackpanel orientation="Horizontal">
<textblock text="{Binding A}"></textblock>
<textblock text="{Binding B}"></textblock>
</stackpanel>
</datatemplate>
</listview.itemtemplate></listview>```

**ViewModel:**

```csharp
public ObservableCollection<recordingviewmodel> Items { get; set; }</recordingviewmodel>

public class RecordingViewModel : INotifyPropertyChanged
{
...
Implement INotifyPropertyChanged
...

private Recording _recording;

public string A
{
get
{
return this._recording.A;
}
set
{
this._recording.A = value;
Notify(nameof(A));
}
}

public string B { get; set; } = this._recording.B;

public RecordingViewModel (Recording recording)
{
this._recording = recording;
}
}
```

**Model:**

```csharp
public class Recording
{
public string A { get; set; }
public string B { get; set; }
public string C { get; set; }
... ...
}
```

比较:

![分离 ViewModel/Model](/img/MVVM_1.png)

## 7.2. UserControl

### 7.2.1. DependencyProperty

* [Dependency Properties Overview](https://docs.microsoft.com/en-us/dotnet/framework/wpf/advanced/dependency-properties-overview)
* 只有 DependencyProperty 能绑定到其它 property, 只有绑定能实现消息通知到 View
* 具有优先级

**View:**

```xml
<mycontrol text="App is on searching" issearching="{Binding ViewModel.IsSearching}"></mycontrol>
```

**ViewModel:**

```csharp
public class MyControl
{
...
public static readonly DependencyProperty IsSearchingProperty =
DependencyProperty.Register
(
"IsSearching", typeof(Boolean),
typeof(MyControl), null
);

public bool IsSearching
{
get { return (bool)GetValue(IsSearchingProperty); }
set { SetValue(IsSearchingProperty, value); }
}
...
}
```

# 8. (ViewModel 与 Model) 数据转换 -- IValueConverter

可以使用**IValueConverter**来进行 ViewModel 和 Model 之间的数据转换.

```csharp
public class ShowAllButtonVisibilityConverter:IValueConverter
{
public object Convert(object value, Type targetType, object parameter, string language)
{
if (value is IList)
{
int count = (value as IList).Count;
if (count &gt; 3)
{
return Windows.UI.Xaml.Visibility.Visible;
}
}
return Windows.UI.Xaml.Visibility.Collapsed;
}

public object ConvertBack(object value, Type targetType, object parameter, string language)
{
if (value is IList)
{
int count = (value as IList).Count;
if (count &gt; 3)
{
return Windows.UI.Xaml.Visibility.Visible;
}
}
return Windows.UI.Xaml.Visibility.Collapsed;
}
```

# 9. (View) 修改 Control 的 Style

## 9.1. 在 Control 里定制 Style

**View:**

```xml
<textblock foreground="Red" text="SampleText"></textblock>
```

## 9.2. 使用统一的 Style -- ResourceDictionary

**View:**

```xml
<window.resources>
<resourcedictionary></resourcedictionary></window.resources>

<style targettype="TextBlock" x:key="ImportantText">
            &amp;amp;amp;lt;Setter Property="Foreground" Value="Red" /&amp;amp;amp;gt;&amp;amp;amp;lt;br /&amp;amp;amp;gt;&amp;lt;br /&amp;gt;
        </style>

...
<textblock text="SampleText" style="{StaticResource" importanttext></textblock>
```

## 9.3. 使用 ThemeResource

**View:**

```xml
<window.resources>
<resourcedictionary>
<resourcedictionary.themedictionaries>
<resourcedictionary x:key="Light"></resourcedictionary></resourcedictionary.themedictionaries></resourcedictionary></window.resources>

<style targettype="TextBlock" x:key="ImportantText">
                    &amp;amp;amp;lt;Setter Property="Foreground" Value="Red" /&amp;amp;amp;gt;&amp;amp;amp;lt;br /&amp;amp;amp;gt;&amp;lt;br /&amp;gt;
                </style>

<resourcedictionary x:key="Dark"></resourcedictionary>

<style targettype="TextBlock" x:key="ImportantText">
                    &amp;amp;amp;lt;Setter Property="Foreground" Value="Yellow" /&amp;amp;amp;gt;&amp;amp;amp;lt;br /&amp;amp;amp;gt;&amp;lt;br /&amp;gt;
                </style>

<resourcedictionary x:key="HighContrast"></resourcedictionary>

<style targettype="TextBlock" x:key="ImportantText">
                    &amp;amp;amp;lt;Setter Property="Foreground" Value="Black" /&amp;amp;amp;gt;&amp;amp;amp;lt;br /&amp;amp;amp;gt;&amp;lt;br /&amp;gt;
                </style>

...
<textblock text="SampleText" style="{ThemeResource" importanttext></textblock>
```

# 10. 使用 Panel

## 10.1. Grid

特点:

* 默认 Height/Width 等于父级元素;

建议:

* 在 Grid 中定义子元素的布局大小;
* 以比例显示;

## 10.2. StackPanel

特点:

* 可以超越父元素边界;
* Height 或 Width 随 Panel 内的元素变化;

建议:

* 灵活使用 Padding 和比例;
* 在父级元素给 StackPanel 的 Width 或 Height 一个值, 以防止 Control 越界;

# 11. (View) 自适应 UI (Adaptive UI)

* 使用 **VisualStateManager.VisualStateGroup**

```xml
<visualstategroup>
<visualstate x:name="WideLayout">
<visualstate.statetriggers>
<adaptivetrigger x:name="WideLayoutTrigger" minwindowwidth="1280"></adaptivetrigger>
</visualstate.statetriggers>
<visualstate.setters>
<setter target="SystemUpdateSideGrid.Width" value="800"></setter>
<setter target="SystemUpdateSideGrid.Grid.Row" value="0"></setter>
</visualstate.setters>
</visualstate></visualstategroup>

<visualstate x:name="MidLayout">
<visualstate.statetriggers>
<adaptivetrigger x:name="MidLayoutTrigger" minwindowwidth="700"></adaptivetrigger>
</visualstate.statetriggers>
<visualstate.setters>
<setter target="SystemUpdateSideGrid.Width" value="400"></setter>
<setter target="SystemUpdateSideGrid.Grid.Row" value="1"></setter>
</visualstate.setters>
</visualstate>
...

```

# 12. 布局原则

* 不显式设定元素的尺寸;
* 不使用屏幕坐标指定元素的位置;
* 容器内子元素共享可用的空间;
* 可嵌套的布局容器;

# 13. 本地化(Localization)

* 使用 x:Uid, 元素的唯一标记符

```xml
<textblock x:uid="S_TextBlock1"></textblock>
```

* 使用 Resources File

```XML
<data name="S_TextBlock1.Text" xml:space="preserve">
<value>Sample text</value>
</data>
```

# 14. 命名方式

大驼峰 big camel-case: **firstName**

小驼峰 little camel-case: **FirstName**

* Class: big camel-case
* Property: big camel-case
* Field: little camel-case with prefix "\_"
* Control in Xaml: little camel-case

# 15. 注意

* 谨慎重命名 ViewModel 中的 Property, 因为 Xaml 中的 Binding 名称不会跟随重构