# -*- encoding: utf-8 -*-
module Dcm4chee
  module Api
    module V1
      class TrashedStudiesController < BaseController
        respond_to :json

        # 查询回收站中研究信息，支持的查询属性有：
        #   patient_id     病人编号
        #
        # 支持的查询操作参见{DmSearch::ClassMethods}
        #
        # @example
        #   # 请求
        #   GET /api/trashed_studies?q[patient_id]=... HTTP/1.1
        #   Accept: application/vnd.menglifang.s2pms.v1
        #
        #   # 响应
        #   HTTP/1.1 200 OK
        #   {
        #     "trashed_studies": [{
        #       "id": ...,
        #       "patient_id": ...,
        #       "study_iuid": ...,
        #       "accession_no": ...,
        #       "dcm_elements": [{
        #         "name": ...,
        #         "value": ...,
        #         "tag": ...,
        #         "value_representation": ...,
        #         "length": ...
        #       }, ...]
        #     }, ...]
        #   }
        def index
          studies = TrashedStudy.search(params[:q])

          respond_with trashed_studies: studies
        end

        # 将研究数据放入回收站（包括相关的研究系列、实例和文件数据），并记录。
        #
        # @example
        #   # 请求
        #   POST /api/trashed_studies HTTP/1.1
        #   Accept: application/vnd.menglifang.s2pms.v1
        #   Content-Type: application/json
        #
        #   { "study_id": ... }
        #
        #   # 响应
        #   HTTP/1.1 201 Created
        def create
          study = Study.get!(params[:study_id])
          study.move_to_trash

          head :created
        end

        # 将研究数据从回收站中删除
        #
        # @example
        #   # 请求
        #   DELETE /api/trashed_studies/... HTTP/1.1
        #   Accept: application/vnd.menglifang.s2pms.v1
        #
        #   # 响应
        #   HTTP/1.1 200 OK
        def destroy
          study = TrashedStudy.get!(params[:id])
          study.remove_from_trash

          head :ok
        end

      end
    end
  end
end
