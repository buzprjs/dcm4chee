# -*- encoding: utf-8 -*-
module Dcm4chee
  module Api
    module V1
      class TrashedSeriesController < BaseController
        respond_to :json

        # 查询回收站研究序列信息，支持的查询属性有：
        #   trashed_study_id     研究编号
        #
        # 支持的查询操作参见{DataMapper::Searcher::ClassMethods}
        #
        # @example
        #   # 请求
        #   GET /api/trashed_series?q[trashed_study_id]=... HTTP/1.1
        #   Accept: application/vnd.menglifang.s2pms.v1
        #
        #   # 响应
        #   HTTP/1.1 200 OK
        #   {
        #     "trashed_series": [{
        #       "id": ...,
        #       "trashed_study_id": ...,
        #       "series_iuid": ...,
        #       "source_aet": ...,
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
          series = TrashedSeries.search(params[:q])

          respond_with trashed_series: series
        end

        # 将研究序列信息放入回收站（包括相关的实例和文件信息），并记录。
        #
        # @example
        #   # 请求
        #   POST /api/trashed_series HTTP/1.1
        #   Accept: application/vnd.menglifang.s2pms.v1
        #   Content-Type: application/json
        #
        #   { "series_id": ... }
        #
        #   # 响应
        #   HTTP/1.1 201 Created
        def create
          series = Series.get!(params[:series_id])
          series.move_to_trash

          head :created
        end

        # 将研究序列信息从回收站中删除
        #
        # @example
        #   # 请求
        #   DELETE /api/trashed_series/... HTTP/1.1
        #   Accept: application/vnd.menglifang.s2pms.v1
        #
        #   # 响应
        #   HTTP/1.1 200 OK
        def destroy
          series = TrashedSeries.get!(params[:id])
          series.remove_from_trash

          head :ok
        end
      end
    end
  end
end
