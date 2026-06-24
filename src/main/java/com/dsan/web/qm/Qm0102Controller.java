package com.dsan.web.qm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dsan.web.qm.service.Qm0102Service;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class Qm0102Controller {
	private static final Logger LOGGER = LoggerFactory.getLogger(Qm0102Controller.class);

	@Autowired
	private Qm0102Service service;

	@RequestMapping(value = "/getDataQcHstyList2", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getDataQcHstyList2(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getDataQcHstyList2(map);
	}

	@RequestMapping(value = "/getHstnTagList_hasRevisnlog", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getHstnTagList_hasRevisnlog(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getHstnTagList_hasRevisnlog(map);
	}
}