package main

import (
	"github.com/gin-gonic/gin"
	"github.com/brianvoe/gofakeit"
	"github.com/PuerkitoBio/goquery"
	"log"
	"net/http"
	"io/ioutil"
)

func main() {
	gofakeit.Seed(time.Now().UnixNano())
	port := "3000"
	router := gin.Default()
	router.GET("/ping", func(c *gin.Context) {
		c.String(200, "pong")
	})
	router.GET("/welcome", func(c *gin.Context) {
		firstname := c.DefaultQuery("firstname", "Guest")
		lastname := c.Query("lastname") // shortcut for c.Request.URL.Query().Get("lastname")

		c.String(http.StatusOK, "Hello %s %s", firstname, lastname)
	})
	router.POST("/form_post", func(c *gin.Context) {
		message := c.PostForm("message")
		nick := c.DefaultPostForm("nick", "anonymous")

		c.JSON(200, gin.H{
			"status":  "posted",
			"message": message,
			"nick":    nick,
		})
	})
	router.POST("/post", func(c *gin.Context) {

		id := c.Query("id")
		page := c.DefaultQuery("page", "0")
		name := c.PostForm("name")
		message := c.PostForm("message")

		fmt.Printf("id: %s; page: %s; name: %s; message: %s", id, page, name, message)
	})
	router.GET("/username", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"username":  gofakeit.Username(),
			"password": gofakeit.Password(true, true, true, true, true, 16),
		})
	}
	router.GET("/tox-nodes", func(c *gin.Context) {
		// Request the HTML page.
		res, err := http.Get("https://nodes.tox.chat/json")
		if err != nil {
			log.Fatal(err)
		}
		defer res.Body.Close()
		if res.StatusCode != 200 {
			log.Fatalf("status code error: %d %s", res.StatusCode, res.Status)
		}
		body, readErr := ioutil.ReadAll(res.Body)
		if readErr != nil {
			log.Fatal(readErr)
		}
		c.String(http.StatusOK, "%s", body)
	}
	router.GET("/tox", func(c *gin.Context) {
		// Request the HTML page.
		res, err := http.Get("https://nodes.tox.chat/")
		if err != nil {
			log.Fatal(err)
		}
		defer res.Body.Close()
		if res.StatusCode != 200 {
			log.Fatalf("status code error: %d %s", res.StatusCode, res.Status)
		}
		// Load the HTML document
		doc, err := goquery.NewDocumentFromReader(res.Body)
		if err != nil {
			log.Fatal(err)
		}
		buf := ""
		doc.Find("table").Each(func(i int, s *goquery.Selection){
			s.Find("tbody").Each(func(i int, s *goquery.Selection){
				s.Find("tr").Each(func(i int, s *goquery.Selection){
					s.Find("td").Each(func(i int, s *goquery.Selection){
						buf += s.Text()
					})
				})
			})
		})

		c.String(http.StatusOK, "%s", buf)
	}

	router.Run(":" + port) // listen and serve on 0.0.0.0:8080
}