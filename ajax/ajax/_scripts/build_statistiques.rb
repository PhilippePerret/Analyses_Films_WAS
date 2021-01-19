# encoding: UTF-8
# frozen_string_literal: true

require_module('statistiques')
Film.current.build_statistiques(Ajax.param(:type))
