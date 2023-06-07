## Install

```bash
v install wygsh.ansi
```

## Example

```go
module main
import wygsh.ansi.graphics

fn main() {
	println(
		graphics.color8(.blue, .fg) + // set a blue foreground color
		'Hello' +
		graphics.color8(.green, .fg) + // set a green one
		'World!'
		graphics.color8(.default, .fg) // reset color to default
	)

	println(
		graphics.rgb([u8(200), 100, 255], .fg) + // set a foreground rgb color
		graphics.style(.underline) // makes text underlined
		'colorful text' +
		graphics.style(.reset_all) // resets all styles and colors
	)
}
```
