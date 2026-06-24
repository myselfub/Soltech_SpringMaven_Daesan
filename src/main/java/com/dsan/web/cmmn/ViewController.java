package com.dsan.web.cmmn;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.dsan.web.cmmn.service.CmmnService;

@Controller
public class ViewController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ViewController.class);
	@Autowired
	private CmmnService service;

	/* 종합관제 - 메인화면 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String homeTiles(Locale locale, Model model) {
		return "db/db0102.page";
	}

	/* 종합관제 - 종합관제 화면 */
	@RequestMapping(value = "/db0102", method = RequestMethod.GET)
	public String home2Tiles(Locale locale, Model model) {
		return "db/db0102.page";
	}

	/* 종합관제 - 시설현황 화면 */
	@RequestMapping(value = "/db0103", method = RequestMethod.GET)
	public String home3Tiles(Locale locale, Model model) {
		return "db/db0103.page";
	}

	/* 에너지관리 - 전력 통계 현황 화면 */
	@RequestMapping(value = "/em0103", method = RequestMethod.GET)
	public String powerStatisticsStatusTiles(Locale locale, Model model) {
		return "em/em0103.page";
	}

	/* 에너지관리 - 전력량 단가 관리 화면 */
	@RequestMapping(value = "/em0104", method = RequestMethod.GET)
	public String classificationOfPowerAmountByProcessTiles(Locale locale, Model model) {
		return "em/em0104.page";
	}

	/* 에너지관리 - 전체 전력 현황 */
	@RequestMapping(value = "/em0105", method = RequestMethod.GET)
	public String em0105(Locale locale, Model model) {
		return "em/em0105.page";
	}

	/* 데이터품질관리 - 데이터 수동 보정 화면 */
	@RequestMapping(value = "/qm0101", method = RequestMethod.GET)
	public String dataCorrectionTiles(Locale locale, Model model) {
		return "qm/qm0101.page";
	}

	/* 데이터품질관리 - 데이터 보정 이력 화면 */
	@RequestMapping(value = "/qm0102", method = RequestMethod.GET)
	public String dataCorrectionHistoryTiles(Locale locale, Model model) {
		return "qm/qm0102.page";
	}

	/* 데이터품질관리 - 결측 데이터 보정 룰 관리 화면 */
	@RequestMapping(value = "/qm0103", method = RequestMethod.GET)
	public String criticalDataManagementTiles(Locale locale, Model model) {
		return "qm/qm0103.page";
	}

	/* AI 시스템(데이터 전처리) - 이벤트 정보 관리 */
	@RequestMapping(value = "/ai0101", method = RequestMethod.GET)
	public String AI0101Tiles(Locale locale, Model model) {
		return "ai/ai0101.page";
	}

	/* AI 시스템(데이터 전처리) - 이벤트 정보 검색 */
	@RequestMapping(value = "/ai0102", method = RequestMethod.GET)
	public String AI0102Tiles(Locale locale, Model model) {
		return "ai/ai0102.page";
	}

	@RequestMapping(value = "/trendView")
	public String trendViewTiles(Locale locale, Model model) {
		return "tv/trendView";
	}

	@RequestMapping(value = "/popup/{mid}/{menu}")
	public String popupViewTiles(Locale locale, Model model, @PathVariable("mid") String midPath,
			@PathVariable("menu") String menuPath) {
		return "pop/" + midPath + "/" + menuPath + ".page";
	}
}