module github.com/layer5io/academy

go 1.24.5

// Manually configured to use a specific commit of Font Awesome , changing the version breaks the build
replace github.com/FortAwesome/Font-Awesome v4.7.0+incompatible => github.com/FortAwesome/Font-Awesome v0.0.0-20241216213156-af620534bfc3
