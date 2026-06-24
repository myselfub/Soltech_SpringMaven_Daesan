package com.dsan.web.qm;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dsan.web.qm.service.Qm0103Service;
import com.dsan.web.qm.vo.RuleVO;

@Controller
public class Qm0103Controller {
	private static final Logger LOGGER = LoggerFactory.getLogger(Qm0103Controller.class);

	@Autowired
	private Qm0103Service service;

	@RequestMapping(value = "/getRuleList")
	@ResponseBody
	public List<RuleVO> getRuleList() throws Exception {
		return service.getRuleList();
	}
}