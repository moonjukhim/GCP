|Name                       |Type       |Description|
|---------------------------|-----|-----|
|fullVisitorId	            |STRING	    |고유한 방문자 ID입니다.|	
|channelGrouping	        |STRING	    |이 보기의 최종 사용자 세션과 연결된 기본 채널 그룹입니다.|	
|time	                    |INTEGER	|이 조회가 등록된 visitStartTime 이후 경과한 시간(단위: 밀리초)입니다. 첫 번째 조회의 hits.time은 0입니다.hits.time|
|country	                |STRING	    |세션이 발생한 국가입니다(IP 주소 기준).geoNetwork.country|	
|city	                    |STRING	    |IP 주소 또는 지역 ID에서 가져온 사용자의 도시입니다.geoNetwork.city	|
|totalTransactionRevenue	|INTEGER	|애널리틱스로 전달된 값으로 표시되는 총 거래 수익.totals.totalTransactionRevenue	|
|transactions	            |INTEGER	|세션 내의 총 전자상거래 수입니다.totals.transactions	|
|timeOnSite	                |INTEGER	|총 세션 시간입니다(단위: 초).totals.timeOnSite	|
|pageviews	                |INTEGER	|세션 내의 총 페이지뷰 수입니다.totals.pageviews	|
|sessionQualityDim	        |INTEGER	|각 세션이 거래에 얼마나 근접했는지를 보여주는 추정치입니다.totals.sessionQualityDim 	|
|date	                    |STRING	    |YYYYMMDD 형식으로 표시되는 세션 날짜입니다.	|
|visitId	                |INTEGER	|이 필드는 더 이상 사용되지 않습니다. 대신 'fullVisitorId'를 사용합니다.|	
|type	                    |STRING	    |조회 유형입니다(예: '페이지', '거래', '품목', '이벤트', '소셜', '앱뷰', '예외').hits.type	|
|productRefundAmount	    |INTEGER	|애널리틱스로 전달된 값으로 표시되는 제품 환불 과정의 처리 금액.hits.product.productRefundAmount|	
|productQuantity	        |INTEGER	|구매된 제품의 수량입니다.hits.product.productQuantity|	
|productPrice	            |INTEGER	|애널리틱스로 전달된 값으로 표시되는 제품 가격.hits.product.productPrice|	
|productRevenue	            |INTEGER	|애널리틱스로 전달된 값으로 표시되는 제품 수익.hits.product.productRevenue|	
|productSKU	                |STRING	    |제품 SKU입니다.hits.product.productSKU|	
|v2ProductName	            |STRING	    |제품명입니다.hits.product.v2ProductName|	
|v2ProductCategory	        |STRING	    |상품 카테고리입니다.hits.product.v2ProductCategory|	
|productVariant	            |STRING	    |유사 제품입니다.hits.product.productVariant|	
|currencyCode	            |STRING	    |거래에 대한 현지 통화 코드입니다.hits.transaction.currencyCode|	
|itemQuantity	            |INTEGER	|판매된 제품의 수량입니다.hits.item.itemQuantity|	
|itemRevenue	            |INTEGER	|애널리틱스로 전달된 값으로 표시되는 총 상품 수익.hits.item.itemRevenue|	
|transactionRevenue	        |INTEGER	|애널리틱스로 전달된 값으로 표시되는 총 거래 수익.hits.transaction.transactionRevenue|	
|transactionId	            |STRING	    |전자상거래의 거래 ID입니다.hits.transaction.transactionId|	
|pageTitle	                |STRING	    |페이지 제목입니다.hits.page.pageTitle|	
|searchKeyword	            |STRING	    |검색결과 페이지인 경우 입력한 키워드입니다.hits.page.searchKeyword|	
|pagePathLevel1	            |STRING	    |pagePath의 첫 번째 계층구조 수준에서 모든 페이지 경로를 롤업하는 측정기준입니다.hits.page.pagePathLevel1|	
|eCommerceAction_type	    |STRING	    |액션 유형입니다. 제품 목록:1,제품 세부정보:2,장바구니에 제품 추가:3,장바구니에서 제품 삭제:4,결제:5,구매 완료:6,구매 환불:7,결제 옵션:8,알 수 없음:0.hits.eCommerceAction.action_type|	
|eCommerceAction_step	    |INTEGER	|조회를 이용해 결제 단계가 지정될 경우 이 필드에 값이 입력됩니다.hits.eCommerceAction.step|	
|eCommerceAction_option	    |STRING	    |이 필드에는 결제 옵션이 지정될 경우에 값이 들어갑니다. 예를 들어 배송 옵션에 'Fedex'가 표시될 수 있습니다.hits.eCommerceAction.option|	

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