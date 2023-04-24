---
layout: ${1|post, page|}
title: ${2:${TM_FILENAME_BASE/[\-_]/ /g}}
published: false
date: ${3:$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE $CURRENT_HOUR:$CURRENT_MINUTE:$CURRENT_SECOND}
categories: ${4|未分类, 书评, 调研, 集群, 操作系统, 运维工具, 开发工具, 数据|}
tags: $4, ${RELATIVE_FILEPATH/.*?([^\\]+)\\[^\\]+.md/$1/g}
---

- [ ] $1, $2

