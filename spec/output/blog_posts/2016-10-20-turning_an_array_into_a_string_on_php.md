---
layout: post
title: "Turning An Array Into A String on PHP"
date: "2016-10-20"
tags: []
---
Alexander Garber

Consider this ugly piece of code:

```// Checkbox handling$field_33_opts = $_POST['field_33'][0]." ,". $_POST['field_33'][1]." ,". $_POST['field_33'][2]." ,". $_POST['field_33'][3]." ,". $_POST['field_33'][4]." ,". $_POST['field_33'][5]." ,". $_POST['field_33'][6]." ,". $_POST['field_33'][7]." ,". $_POST['field_33'][8]." ,". $_POST['field_33'][9]." ,". $_POST['field_33'][10]." ,". $_POST['field_33'][11];```

Doesn't this look better?

```// Checkbox handling$field_33_opts = implode(" ," , $_POST['field_33']);```