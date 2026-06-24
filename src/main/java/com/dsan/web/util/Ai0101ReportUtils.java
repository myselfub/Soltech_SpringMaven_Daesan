package com.dsan.web.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.util.ObjectUtils;

import com.dsan.web.ai.vo.EvntVO;

public class Ai0101ReportUtils {
	private final ServletContext servletContext;
	private final String filePath = "/resources/template/";
	private final String templateName = "AI0101_Template.xlsx";

	public Ai0101ReportUtils(ServletContext servletContext) {
		this.servletContext = servletContext;
	}

	public void setExcelDatas(HttpServletResponse response, String fileName, String ymd, List<EvntVO> datas)
			throws IOException {
		File excelFile = new File(servletContext.getRealPath(filePath) + File.separator + templateName);

		if (!excelFile.exists()) {
			throw new IOException("No Files.");
		}

		try (FileInputStream fileInputStream = new FileInputStream(excelFile)) {
			Workbook workbook = new XSSFWorkbook(fileInputStream);

			for (int sheetNum = 0; sheetNum < workbook.getNumberOfSheets(); sheetNum++) {
				// 첫번째 시트만 가져오게.(추후 유지보수를 위해 여러개 가져오는 로직만 추가해둠)
				if (sheetNum > 0) {
					break;
				}

				Map<String, List<EvntVO>> listMap = new LinkedHashMap<String, List<EvntVO>>();
				listMap.put("1", new ArrayList<EvntVO>());
				listMap.put("2", new ArrayList<EvntVO>());
				listMap.put("3", new ArrayList<EvntVO>());
				listMap.put("etc", new ArrayList<EvntVO>());
				int dayStart = 9;
				int dayEnd = 18;
				Set<String> seNmSet = new LinkedHashSet<String>();
				Set<String> wrkrSetDay = new LinkedHashSet<String>();
				Set<String> wrkrSetNight = new LinkedHashSet<String>();
				datas.forEach(evntVO -> {
					if ("1".equals(evntVO.getEvnt_se())) {
						listMap.get("1").add(evntVO);
						seNmSet.add(evntVO.getEvnt_se_nm());
					} else if ("2".equals(evntVO.getEvnt_se())) {
						listMap.get("2").add(evntVO);
						seNmSet.add(evntVO.getEvnt_se_nm());
					} else if ("3".equals(evntVO.getEvnt_se())) {
						listMap.get("3").add(evntVO);
						seNmSet.add(evntVO.getEvnt_se_nm());
					} else {
						listMap.get("etc").add(evntVO);
						seNmSet.add("기타");
					}
					if (!ObjectUtils.isEmpty(evntVO.getWrkr())) {
						String dt = evntVO.getBgng_dt();
						LocalTime time = LocalDateTime.parse(dt, DateTimeFormatter.ofPattern("yyyyMMddHHmm"))
								.toLocalTime();
						if (time.isAfter(LocalTime.of(dayStart, 0)) && time.isBefore(LocalTime.of(dayEnd, 0))) {
							wrkrSetDay.addAll(Arrays.asList(evntVO.getWrkr().split("[,./ :;]")));
						} else {
							wrkrSetNight.addAll(Arrays.asList(evntVO.getWrkr().split("[,./ :;]")));
						}
					}
				});

				Sheet sheet = workbook.getSheetAt(sheetNum);

				CellStyle cellStyleWrkr = workbook.createCellStyle();
				cellStyleWrkr.setWrapText(true);
				cellStyleWrkr.setAlignment(HorizontalAlignment.LEFT);
				cellStyleWrkr.setVerticalAlignment(VerticalAlignment.CENTER);
				cellStyleWrkr.setBorderTop(BorderStyle.THIN);
				cellStyleWrkr.setBorderRight(BorderStyle.THIN);
				cellStyleWrkr.setBorderBottom(BorderStyle.THIN);
				cellStyleWrkr.setBorderLeft(BorderStyle.THIN);

				CellStyle cellStyleSeNm = workbook.createCellStyle();
				cellStyleSeNm.setWrapText(true);
				cellStyleSeNm.setAlignment(HorizontalAlignment.CENTER);
				cellStyleSeNm.setVerticalAlignment(VerticalAlignment.CENTER);

				CellStyle cellStyleCn = workbook.createCellStyle();
				cellStyleCn.setWrapText(true);
				cellStyleCn.setAlignment(HorizontalAlignment.LEFT);
				cellStyleCn.setVerticalAlignment(VerticalAlignment.TOP);
				cellStyleCn.setBorderTop(BorderStyle.THIN);
				cellStyleCn.setBorderRight(BorderStyle.THIN);
				cellStyleCn.setBorderBottom(BorderStyle.THIN);
				cellStyleCn.setBorderLeft(BorderStyle.THIN);

				int dateRowIdx = 4;
				int dateColIdx = 1;
				Row dateRow = sheet.getRow(dateRowIdx);
				if (dateRow == null) {
					sheet.createRow(dateRowIdx);
				}
				Cell dateCell = dateRow.getCell(dateColIdx);
				if (dateCell == null) {
					dateRow.createCell(dateColIdx);
				}

				String dateValue = dateCell.getStringCellValue();
				if (ObjectUtils.isEmpty(dateValue)) {
					dateValue = "    yyyy년    MM월    dd일    E요일";
				}
				LocalDate now = LocalDate.parse(ymd, DateTimeFormatter.ofPattern("yyyyMMdd"));
				dateValue = dateValue.replace("yyyy", String.valueOf(now.getYear()))
						.replace("MM", String.valueOf(now.getMonthValue()))
						.replace("dd", String.valueOf(now.getDayOfMonth())).replace("E",
								String.valueOf(now.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN)));
				dateCell.setCellValue(dateValue);

				List<String> wrkrListDay = new ArrayList<String>(wrkrSetDay);
				StringBuilder stringBuilderWrkr = new StringBuilder();
				for (int idx = 0; idx < wrkrListDay.size(); idx++) {
					String wrkrNm = wrkrListDay.get(idx);
					if (!ObjectUtils.isEmpty(wrkrNm)) {
						stringBuilderWrkr.append(wrkrNm);
						if (idx != (wrkrListDay.size() - 1)) {
							stringBuilderWrkr.append(",");
						}
					}
				}
				setCellValue(sheet, 7, 2, stringBuilderWrkr.toString(), cellStyleWrkr);

				List<String> wrkrListNight = new ArrayList<String>(wrkrSetNight);
				stringBuilderWrkr.setLength(0);
				for (int idx = 0; idx < wrkrListNight.size(); idx++) {
					String wrkrNm = wrkrListNight.get(idx);
					if (!ObjectUtils.isEmpty(wrkrNm)) {
						stringBuilderWrkr.append(wrkrNm);
						if (idx != (wrkrListNight.size() - 1)) {
							stringBuilderWrkr.append(",");
						}
					}
				}
				setCellValue(sheet, 7, 7, stringBuilderWrkr.toString(), cellStyleWrkr);

				int rowIdx = 8;
				int colIdx = 1;
				final int maxColIdx = 11;
				int seNmIdx = 0;
				Iterator<String> keyIterator = listMap.keySet().iterator();
				while (keyIterator.hasNext()) {
					String key = keyIterator.next();

					StringBuilder stringBuilder = new StringBuilder();
					for (int idx = 0; idx < listMap.get(key).size(); idx++) {
						if (listMap.get(key).get(idx) != null) {
							if (!ObjectUtils.isEmpty(listMap.get(key).get(idx).getEvnt_cn())
									|| !ObjectUtils.isEmpty(listMap.get(key).get(idx).getEvnt_cn2())) {
								String bgngDt = !ObjectUtils.isEmpty(listMap.get(key).get(idx).getBgng_dt())
										? listMap.get(key).get(idx).getBgng_dt().substring(8, 10) + ":"
												+ listMap.get(key).get(idx).getBgng_dt().substring(10, 12)
										: "";
								String endDt = !ObjectUtils.isEmpty(listMap.get(key).get(idx).getEnd_dt())
										? listMap.get(key).get(idx).getEnd_dt().substring(8, 10) + ":"
												+ listMap.get(key).get(idx).getEnd_dt().substring(10, 12)
										: "";
								stringBuilder.append(" " + (idx + 1) + ". " + bgngDt + " ~ " + endDt + "\n");
								String evntCn = !ObjectUtils.isEmpty(listMap.get(key).get(idx).getEvnt_cn())
										? replaceCn(listMap.get(key).get(idx).getEvnt_cn()) : "";
								stringBuilder.append("    - 내용:\n        " + evntCn + "\n");
								String evntCn2 = !ObjectUtils.isEmpty(listMap.get(key).get(idx).getEvnt_cn2())
										? replaceCn(listMap.get(key).get(idx).getEvnt_cn2()) : "";
								stringBuilder.append("    - 조치:\n        " + evntCn2 + "\n");
							}
						}
					}
					if (!ObjectUtils.isEmpty(stringBuilder.toString())) {
						long enterCount = stringBuilder.toString().chars().filter(ch -> ch == '\n').count() + 3;
						int mergeRowIdx = (int) (rowIdx + enterCount); // rowIdx+evntSe1List.size()

						cellMerge(sheet, rowIdx, mergeRowIdx, colIdx, colIdx, cellStyleCn);
						setCellValue(sheet, rowIdx, colIdx++, seNmSet.stream().skip(seNmIdx++).findFirst().orElse(""),
								cellStyleSeNm);

						cellMerge(sheet, rowIdx, mergeRowIdx, colIdx, maxColIdx, cellStyleCn);

						setCellValue(sheet, rowIdx, colIdx, stringBuilder.toString(), cellStyleCn);
						rowIdx = mergeRowIdx + 1;
						colIdx--;
					}
				}
			}

			String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName + ".xlsx");
			response.setHeader("Content-Transfer-Encoding", "binary");
			workbook.write(response.getOutputStream());

			workbook.close();
		}
	}

	private void setCellValue(Sheet sheet, int rowIdx, int colIdx, String value, CellStyle cellStyle) {
		Row row = sheet.getRow(rowIdx);
		if (row == null) {
			row = sheet.createRow(rowIdx);
		}
		Cell cell = row.getCell(colIdx);
		if (cell == null) {
			cell = row.createCell(colIdx);
		}
		if (cellStyle != null) {
			cell.setCellStyle(cellStyle);
		}

		cell.setCellValue(value);
	}

	private void cellMerge(Sheet sheet, int startRowIdx, int endRowIdx, int startColIdx, int endColIdx,
			CellStyle cellStyle) {
		CellRangeAddress cellRangeAddress = new CellRangeAddress(startRowIdx, endRowIdx, startColIdx, endColIdx);
		sheet.addMergedRegion(cellRangeAddress);
		if (cellStyle != null) {
			for (int rowIdx = cellRangeAddress.getFirstRow(); rowIdx <= cellRangeAddress.getLastRow(); rowIdx++) {
				Row row = sheet.getRow(rowIdx);
				if (row == null) {
					row = sheet.createRow(rowIdx);
				}
				for (int colIdx = cellRangeAddress.getFirstColumn(); colIdx <= cellRangeAddress
						.getLastColumn(); colIdx++) {
					Cell cell = row.getCell(colIdx);
					if (cell == null) {
						cell = row.createCell(colIdx);
					}
					cell.setCellStyle(cellStyle);
				}
			}
		}
	}

	private String replaceCn(String evntCn) {
		String enter = "\n        ";
		evntCn = evntCn.replace("&nbsp;", " ");
		evntCn = evntCn.replace("<br/>\r\n", enter);
		evntCn = evntCn.replace("<br/>\r", enter);
		evntCn = evntCn.replace("<br/>\n", enter);
		evntCn = evntCn.replace("<br />\r\n", enter);
		evntCn = evntCn.replace("<br />\r", enter);
		evntCn = evntCn.replace("<br />\n", enter);
		evntCn = evntCn.replace("<br/>", enter);
		evntCn = evntCn.replace("<br />", enter);
		evntCn = evntCn.replace("\r\n", enter);
		evntCn = evntCn.replace("\r", enter);

		return evntCn;
	}
}