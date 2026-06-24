package com.dsan.web.em;

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

import com.dsan.web.em.service.Em0104Service;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class Em0104Controller {
	private static final Logger LOGGER = LoggerFactory.getLogger(Em0104Controller.class);

	@Autowired
	private Em0104Service service;

	@RequestMapping(value = "/getBeforeUntPrcInfo", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getBeforeUntPrcInfo(@RequestBody String param) throws Exception {
		return service.getBeforeUntPrcInfo();
	}

	@RequestMapping(value = "/getPwrerUntPrcMst", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getPwrerUntPrcMst(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getPwrerUntPrcMst(map);
	}

	@RequestMapping(value = "/getPwrerUntMng", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getPwrerUntMng(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getPwrerUntMng(map);
	}

	@RequestMapping(value = "/onSaveUntPrcAndHour", produces = "application/json; charset=utf8")
	@ResponseBody
	public int onSaveUntPrcAndHour(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});

		List<HashMap<String, Object>> UntPrcList = (List<HashMap<String, Object>>) map.get("untprc_list");
		int up = service.onSaveUntPrc(UntPrcList);

		List<HashMap<String, Object>> HourList = (List<HashMap<String, Object>>) map.get("hourlist");
		int hs = service.onSaveHourSetting(HourList);

		return up + hs;
	}

	@RequestMapping(value = "/getUsgPrcValues", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getUsgPrcValues(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getUsgPrcValues(map);
	}
}