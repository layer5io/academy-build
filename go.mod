module github.com/layer5io/academy

go 1.24.5

// Manually configured to use a specific commit of Font Awesome , changing the version breaks the build
replace github.com/FortAwesome/Font-Awesome v4.7.0+incompatible => github.com/FortAwesome/Font-Awesome v0.0.0-20241216213156-af620534bfc3

// replace github.com/layer5io/academy-theme => ../academy-theme

require (
	github.com/FortAwesome/Font-Awesome v4.7.0+incompatible // indirect
	github.com/layer5io/academy-theme v0.4.2 // indirect
	github.com/layer5io/digitalocean-academy v0.1.12 // indirect
	github.com/layer5io/exoscale-academy v0.6.23 // indirect
	github.com/layer5io/layer5-academy v0.8.6 // indirect
	github.com/meshery-extensions/meshery-academy v0.4.9 // indirect
	github.com/twbs/bootstrap v5.3.8+incompatible // indirect
)
