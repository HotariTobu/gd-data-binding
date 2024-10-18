![icon](assets/icon.svg)

# GD Data Binding

GD Data Binding is a Godot library that simplifies your UI coding by automatically syncing data between views and models.

## Demo

![buttons demo](images/buttons.gif)
![containers demo](images/containers.gif)
![edits demo](images/edits.gif)
![ranges demo](images/ranges.gif)
![notification demo](images/notification.gif)

## Example

See the usage in [`examples`](examples).

## MVVM

GD Data Binding is based on the MVVM pattern.
In the pattern, the application UI and logic are separated into three components: View, ViewModel, and Model;

```mermaid
graph LR
  A(View)
  B(ViewModel)
  C(Model)
  A -- Data Binding --> B
  B -- Update --> C
  C -- Notify --> B
  B -- Notify --> A
```

Reference: https://learn.microsoft.com/dotnet/architecture/maui/mvvm

For example, imagine to create a counter.
The view has a label to show the counted number and a button to count up the number.

![counter demo](images/counter.gif)

The basic way to update the label content is that the button-pressed handler increases the count value and assigns it to the `text` of the label.
