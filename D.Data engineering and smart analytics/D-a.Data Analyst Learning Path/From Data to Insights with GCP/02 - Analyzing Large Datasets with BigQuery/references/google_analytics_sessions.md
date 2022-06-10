### ecommerce sample data schema

|Name                                         |Type       |Description|
|---------------------------------------------|-----|-----|
|fullVisitorId	                              |STRING	    |고유한 방문자 ID|	
|channelGrouping	                            |STRING	    |이 보기의 최종 사용자 세션과 연결된 기본 채널 그룹|
|hits.eCommerceAction.eCommerceAction_type	  |STRING	    |액션 유형 제품 목록:1,제품 세부정보:2,장바구니에 제품 추가:3,장바구니에서 제품 삭제:4,결제:5,구매 완료:6,구매 환불:7,결제 옵션:8,알 수 없음:0|	
|hits.eCommerceAction.eCommerceAction_step	  |INTEGER	  |조회를 이용해 결제 단계가 지정될 경우 이 필드에 값이 입력|	
|hits.eCommerceAction.eCommerceAction_option  |STRING	    |이 필드에는 결제 옵션이 지정될 경우에 값이 들어갑니다. 예를 들어 배송 옵션에 'Fedex'|		
|hits.item.itemQuantity	                      |INTEGER	  |판매된 제품의 수량|	
|hits.item.itemRevenue                        |INTEGER	  |애널리틱스로 전달된 값으로 표시되는 총 상품 수익|	
|hits.time	                                  |INTEGER	  |이 조회가 등록된 visitStartTime 이후 경과한 시간(단위: 밀리초) 첫 번째 조회는 0|
|hits.type                                    |STRING	    |조회 유형(예: '페이지', '거래', '품목', '이벤트', '소셜', '앱뷰', '예외')	|
|hits.page.pageTitle	                        |STRING	    |페이지 제목|	
|hits.page.searchKeyword	                    |STRING	    |검색결과 페이지인 경우 입력한 키워드|	
|hits.page.pagePathLevel1                     |STRING	    |pagePath의 첫 번째 계층구조 수준에서 모든 페이지 경로를 롤업하는 측정기준|	
|hits.product.productRefundAmount             |INTEGER	  |애널리틱스로 전달된 값으로 표시되는 제품 환불 과정의 처리 금액|	
|hits.product.productQuantity                 |INTEGER	  |구매된 제품의 수량|	
|hits.product.productPrice                    |INTEGER	  |애널리틱스로 전달된 값으로 표시되는 제품 가격|	
|hits.product.productRevenue                  |INTEGER	  |애널리틱스로 전달된 값으로 표시되는 제품 수익|	
|hits.product.productSKU                      |STRING	    |제품 SKU |	
|hits.product.v2ProductName                   |STRING	    |제품명 |	
|hits.product.v2ProductCategory               |STRING	    |상품 카테고리 |	
|hits.product.productVariant                  |STRING	    |유사 제품 |
|hits.transaction.currencyCode                |STRING	    |거래에 대한 현지 통화 코드입니다.|	
|hits.transaction.transactionRevenue          |INTEGER	  |애널리틱스로 전달된 값으로 표시되는 총 거래 수익.|	
|hits.transaction.transactionId	              |STRING	    |전자상거래의 거래 ID입니다.|	
|geoNetwork.country                           |STRING	    |세션이 발생한 국가입니다(IP 주소 기준)|	
|geoNetwork.city	                            |STRING	    |IP 주소 또는 지역 ID에서 가져온 사용자의 도시입니다.	|
|totals.totalTransactionRevenue	              |INTEGER	  |애널리틱스로 전달된 값으로 표시되는 총 거래 수익	|
|totals.timeOnSite                            |INTEGER	  |총 세션 시간(단위:초)	|
|totals.pageviews	                            |INTEGER	  |세션 내의 총 페이지뷰 수입니다.	|
|totals.sessionQualityDim	                    |INTEGER	  |각 세션이 거래에 얼마나 근접했는지를 보여주는 추정치입니다. 	|
|transactions.transactions                    |INTEGER	  |세션 내의 총 전자상거래 수입니다.	|
|date	                                        |STRING	    |YYYYMMDD 형식으로 표시되는 세션 날짜입니다.	|
|visitId	                                    |INTEGER	  |이 필드는 더 이상 사용되지 않습니다. 대신 'fullVisitorId'를 사용합니다.|	


	






[from](https://support.google.com/analytics/answer/3437719?hl=ko&ref_topic=3416089)

2017년 7월에 사용자가 조회한 페이지 순서

```sql
#standardSQL
SELECT
fullVisitorId,
visitId,
visitNumber,
hits.hitNumber AS hitNumber,
hits.page.pagePath AS pagePath
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) as hits
WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
AND hits.type="PAGE"
ORDER BY fullVisitorId, visitId, visitNumber,hitNumber
```