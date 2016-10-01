
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sex` tinyint(2) DEFAULT '1' COMMENT '性别 0保密 1 男 2 女',
  `name` varchar(100) NOT NULL,
  `nick_name` varchar(100) NOT NULL DEFAULT '' COMMENT '昵称',
  `phone` varchar(11) NOT NULL,
  `email` varchar(255) DEFAULT '',
  `qq` varchar(21) DEFAULT '',
  `birthday` varchar(255) NOT NULL DEFAULT '' COMMENT '生日',
  `relationship` tinyint(4) NOT NULL DEFAULT '0' COMMENT '关系id',
  `intimacy` int(2) DEFAULT '50' COMMENT '亲密度 最大为100',
  `company` varchar(255) NOT NULL DEFAULT '' COMMENT '公司',
  `profession` varchar(255) NOT NULL DEFAULT '' COMMENT '职位',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
