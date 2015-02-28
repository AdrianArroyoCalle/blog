---
layout: page
title: Status
description: Status of my projects
keywords:
 - status
---

Status
======


## General

![Gratipay](https://img.shields.io/gratipay/710151044cb9.svg)
![GitHub followers](https://img.shields.io/github/followers/AdrianArroyoCalle.svg)

## Projects

<table>
	<th>
				<td>Name</td>
				<td>Description</td>
				<td>Logo</td>
				<td>Travis CI</td>
				<td>AppVeyor</td>
				<td>Drone.io</td>
				<td>Coveralls</td>
				<td>npm downloads</td>
				<td>apm</td>
				<td>NuGet</td>
				<td>Chocolatey</td>
				<td>Crates.io</td>
				<td>npm version</td>
				<td>Crates.io version</td>
				<td>Bower</td>
				<td>GitHub tag</td>
				<td>GitHub release</td>
				<td>NuGet release</td>
				<td>Chocolatey release</td>
				<td>apm release</td>
				<td>Bountysource</td>
				<td>Code Climate version</td>
				<td>Code Climate percentage</td>
				<td>David deps</td>
				<td>David devDeps</td>
				<td>David peerDeps</td>
				<td>Crates.io license</td>
				<td>Requires.io</td>
				<td>VersionEye</td>
				<td>npm license</td>
				<td>GitHub issues</td>
				<td>GitHub forks</td>
				<td>GitHub stars</td>
				<td>License</td>
				<td>Language</td>
				<td>Operating System</td>
				<td>SCM</td>
	</th>
{% for project in site.data.projects.projects %}
	<tr>
		<td></td>
		<td>{{ project.name }}</td>
		<td>{{ project.description }}</td>
		<td><img src="{{ project.logo}}" alt="Logo for {{ project.name }}"></td>
		<td><img src="http://img.shields.io/travis/{{ project.services.travis }}.svg" alt="Travis"></td>
		<td><img src="http://img.shields.io/appveyor/ci/{{ project.services.appveyor }}.svg" alt="AppVeyor"></td>
		<td><img src="http://img.shields.io/travis/{{ project.services.travis }}.svg" alt="Drone.io"></td>
		<td><img src="http://img.shields.io/coveralls/{{ project.services.coveralls }}.svg" alt="Coveralls"></td>
		<td><img src="http://img.shields.io/npm/dm/{{ project.services.npm }}.svg" alt="npm downloads"></td>
		<td><img src="http://img.shields.io/apm/dm/{{ project.services.apm }}.svg" alt="apm downloads"></td>
		<td><img src="http://img.shields.io/nuget/dt/{{ project.services.nuget }}.svg" alt="NuGet"></td>
		<td><img src="http://img.shields.io/chocolatey/dt/{{ project.services.chocolatey }}.svg" alt="Chocolatey"></td>
		<td><img src="http://img.shields.io/crates/d/{{ project.services.crates }}.svg" alt="Crates.io"></td>
		<td><img src="http://img.shields.io/npm/v/{{ project.services.npm }}.svg" alt="npm version"></td>
		<td><img src="http://img.shields.io/crates/v/{{ project.services.crates }}.svg" alt="Crates.io version"></td>
		<td><img src="http://img.shields.io/bower/v/{{ project.services.bower }}.svg" alt="Bower"></td>
		<td><img src="http://img.shields.io/github/tag/{{ project.services.github }}.svg" alt="GitHub tag"></td>
		<td><img src="http://img.shields.io/github/release/{{ project.services.github }}.svg" alt="GitHub release"></td>
		<td><img src="http://img.shields.io/nuget/v/{{ project.services.nuget }}.svg" alt="NuGet release"></td>
		<td><img src="http://img.shields.io/chocolatey/v/{{ project.services.chocolatey }}.svg" alt="Chocolatey release"></td>
		<td><img src="http://img.shields.io/apm/v/{{ project.services.apm }}.svg" alt="apm release"></td>
		<td><img src="http://img.shields.io/bountysource/{{ project.services.github }}.svg" alt="Bountysource"></td>
		<td><img src="http://img.shields.io/codeclimate/github/{{ project.services.github }}.svg" alt="Code Climate version"></td>
		<td><img src="http://img.shields.io/codeclimate/coverage/github/{{ project.services.github }}.svg" alt="Code Climate percentage"></td>
		<td><img src="http://img.shields.io/david/{{ project.services.github }}.svg" alt="David deps"></td>
		<td><img src="http://img.shields.io/david/dev/{{ project.services.github }}.svg" alt="David devDeps"></td>
		<td><img src="http://img.shields.io/david/peer/{{ project.services.github }}.svg" alt="David peerDeps"></td>
		<td><img src="http://img.shields.io/crates/l/{{ project.services.crates }}.svg" alt="Crates.io license"></td>
		<td><img src="http://img.shields.io/requires/github/{{ project.services.github }}.svg" alt="Requires.io"></td>
		<td><img src="http://img.shields.io/versioneye/d/{{ project.services.github }}.svg" alt="VersionEye"></td>
		<td><img src="http://img.shields.io/npm/l/{{ project.services.npm }}.svg" alt="npm license"></td>
		<td><img src="http://img.shields.io/github/issues/{{ project.services.github }}.svg" alt="GitHub issues"></td>
		<td><img src="http://img.shields.io/github/forks/{{ project.services.github }}.svg" alt="GitHub forks"></td>
		<td><img src="http://img.shields.io/github/stars/{{ project.services.github }}.svg" alt="GitHub stars"></td>
		<td><img src="http://img.shields.io/badge/license-{{ project.license }}-blue.svg" alt="License"></td>
		<td><img src="http://img.shields.io/badge/language-{{ project.lang }}-yellow.svg" alt="Language"></td>
		<td><img src="http://img.shields.io/badge/os-{{ project.os }}-green.svg" alt="Operating System"></td>
		<td><img src="http://img.shields.io/badge/scm-{{ project.scm }}-orange.svg" alt="SCM"></td>
	</tr>
{% endfor %}
</table>
