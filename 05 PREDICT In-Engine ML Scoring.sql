
-- PREDICTIVE MODELS TABLE
SELECT * FROM Models;

-- TRIPS DATA TABLE
select * from dbo.Trips

-- quick predict
SELECT TOP 10
       [vendorID],
       [passengerCount],
       [tripDistance],
       [month_num],
       [day_of_month],
       [day_of_week],
       [day_of_hour],
       [totalAmount]
FROM PREDICT (model = (SELECT Model FROM Models WHERE Id = 60), Data = dbo.Trips) WITH (totalAmount float)


-- NEXT PREDICTIONS INTO A MORE COMPLEX QUERY
--DECLARE @model varbinary(max) = (SELECT Model FROM Models WHERE Id = 60);
SELECT
	PassengerCount,
	TripCount,
	AvgTripAmount,
	RANK() OVER (ORDER BY AvgTripAmount DESC) AS RankTripAmount
FROM (
	SELECT 
		   [passengerCount]		as PassengerCount,
		   COUNT(*)				as TripCount,
		   AVG([totalAmount])	as AvgTripAmount
	FROM PREDICT (model = (SELECT Model FROM Models WHERE Id = 60), Data = dbo.TaxiTrips5M) WITH (totalAmount float)
	GROUP BY
		[passengerCount]) SubQ
ORDER BY
	PassengerCount

  
-- DROP VIEW
DROP VIEW vw_PredictedTripAmount

-- CREATE VIEW
CREATE VIEW vw_PredictedTripAmount
AS
SELECT [vendorID],
       [passengerCount],
       [tripDistance],
       [month_num],
       [day_of_month],
       [day_of_week],
       [day_of_hour],
       [totalAmount]
FROM PREDICT (model = (SELECT Model FROM Models WHERE Id = 59), Data = dbo.TaxiTrips5M) WITH (totalAmount float)
  
  
-- SELECT TOP 10
SELECT TOP 10 * FROM vw_PredictedTripAmount
