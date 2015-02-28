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
				<td>Google+ like</td>
				<td>License</td>
				<td>Language</td>
				<td>Operating System</td>
				<td>SCM</td>
	</th>
{% for project in site.data.projects.projects %}
	<tr>
		<td>{{ project.name }}</td>
		<td>{{ project.description }}</td>
		<td><img src="{{ project.logo}}" alt="Logo for {{ project.name }}"></td>
		<td><img src="http://img.shields.io/travis/{{ project.travis }}.svg" alt="Travis"></td>
	</tr>
{% endfor %}
</table>
