package com.dsan.web.em;

import com.dsan.web.em.service.Em0103Service;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
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

@Controller
public class Em0103Controller {
	private static final Logger LOGGER = LoggerFactory.getLogger(Em0103Controller.class);
	@Autowired
	private Em0103Service service;

	@RequestMapping(value = { "/getChartStatisticsData" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartStatisticsData(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartStatisticsData(map);
	}

	@RequestMapping(value = { "/getChartPwereUsgPrc" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartPwereUsgPrc(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.PwereUsgPrc(map);
	}

	// 공정별 실시간 전력 조회
	@RequestMapping(value = { "/getProcsRealTimePower" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getProcsRealTimePower(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getProcsRealTimePower(map);
	}

	// 공정별 금일 최대 전력 조회
	@RequestMapping(value = { "/getProcsMaxPower" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getProcsMaxPower(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getProcsMaxPower(map);
	}

	// 공정별 소비 전력량 조회
	@RequestMapping(value = { "/getProcsPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getProcsPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getProcsPowerUsage(map);
	}

	// 공정별 소비 요금 조회
	@RequestMapping(value = { "/getProcsPowerCost" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getProcsPowerCost(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getProcsPowerCost(map);
	}

	// 공정별 시간별 전력량 조회 (차트용)
	@RequestMapping(value = { "/getProcsHourlyPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getProcsHourlyPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getProcsHourlyPowerUsage(map);
	}
}
