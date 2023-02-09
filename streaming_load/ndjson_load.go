package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"mime/multipart"
	"net/http"
	"strings"
)

type StreamLoad struct {
	url       string
	dbName    string
	tableName string
	data      string
	userName  string
	password  string
	fType	  string
}

func auth(load StreamLoad) string {
	s := load.userName + ":" + load.password
	b := []byte(s)
	sEnc := base64.StdEncoding.EncodeToString(b)

	_, err := base64.StdEncoding.DecodeString(sEnc)
	if err != nil {
		fmt.Printf("base64 decode failure, error=[%v]\n", err)
	}
	return sEnc
}

func stream_load(load StreamLoad, data string) {
	client := &http.Client{}
	
	url := load.url
	//提交请求
	body, writer := io.Pipe()
	req, err := http.NewRequest(http.MethodPut, url, body)
	if err != nil {
		panic(err)
	}
	insert_sql := fmt.Sprintf("insert into %s.%s file_format=(type=%s)", load.dbName, load.tableName, load.fType)
	mwriter := multipart.NewWriter(writer)
	req.Header.Add("Content-Type", mwriter.FormDataContentType())
	req.Header.Add("Authorization", "Basic "+auth(load))
	req.Header.Add("insert_sql", insert_sql)
	errchan := make(chan error)

	go func() {
		defer close(errchan)
		defer writer.Close()
		defer mwriter.Close()

		w, err := mwriter.CreateFormFile("ndjson", "upload.ndjson")
		if err != nil {
			errchan <- err
			return
		}

		in := strings.NewReader(data)

		if written, err := io.Copy(w, in); err != nil {
			errchan <- fmt.Errorf("error copying %s (%d bytes written): %v", data, written, err)
			return
		}

		if err := mwriter.Close(); err != nil {
			errchan <- err
			return
		}
	}()

	response, err := client.Do(req)
	if err != nil {
		panic(err)
	}

	if response.StatusCode == 200 {
		body, _ := ioutil.ReadAll(response.Body)
		responseBody := ResponseBody{}
		jsonStr := string(body)
		if err := json.Unmarshal(body, &responseBody); err == nil {
			if responseBody.State != "SUCCESS" {
				fmt.Printf("has failed: [%v]", responseBody)
			}
		} else {
			panic(err)
		}
		fmt.Printf("%s", jsonStr)
	} else {
		body, _ := ioutil.ReadAll(response.Body)
		fmt.Printf("the error is {%s}", body)
	}
	defer response.Body.Close()
}

type Stats struct {
	Rows  int64 `json:"rows"`
	Bytes int64 `json:"bytes"`
}

//Stream load 返回消息结构体
type ResponseBody struct {
	Id    string   `json:"id"`
	State string   `json:"state"`
	Stats Stats    `json:"stats"`
	Error string   `json:"error"`
	Files []string `json:"files"`
}

/*
CREATE TABLE `tb_1` (
  `id` INT,
  `name` VARCHAR,
  `ss` VARCHAR
)

create user 'wubx'@'%' identified by 'wubxwubx';

grant all on *.* to 'wubx'@'%';
*/
func main() {
	var load StreamLoad
	load.userName = "wubx"
	load.password = "wubxwubx"
	load.dbName = "default"
	load.tableName = "tb_1"
	load.fType = "ndjson"
	load.url = "http://192.168.191.96:8000/v1/streaming_load"

	id := 1
	name := "Winter"
	ss := "cloud"
	data := ""
	mapData := make(map[string]interface{})
	for i := 0; i < 10; i++ {
		mapData["id"]=id
		mapData["name"]=name 
		mapData["ss"]=ss
		bytes, _ := json.Marshal(mapData)
		data += string(bytes)+"\n"
	}

	stream_load(load, data)
}