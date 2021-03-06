# frozen_string_literal: true

module SidekiqUniqueJobs
  module Redis
    #
    # Class Entity functions as a base class for redis types
    #
    # @author Mikael Henriksson <mikael@zoolutions.se>
    #
    class Entity
      # includes "SidekiqUniqueJobs::Logging"
      # @!parse include SidekiqUniqueJobs::Logging
      include SidekiqUniqueJobs::Logging

      # includes "SidekiqUniqueJobs::Script::Caller"
      # @!parse include SidekiqUniqueJobs::Script::Caller
      include SidekiqUniqueJobs::Script::Caller

      # includes "SidekiqUniqueJobs::JSON"
      # @!parse include SidekiqUniqueJobs::JSON
      include SidekiqUniqueJobs::JSON

      # includes "SidekiqUniqueJobs::Timing"
      # @!parse include SidekiqUniqueJobs::Timing
      include SidekiqUniqueJobs::Timing

      #
      # @!attribute [r] key
      #   @return [String] the redis key for this entity
      attr_reader :key

      #
      # Initialize a new Entity
      #
      # @param [String] key the redis key for this entity
      #
      def initialize(key)
        @key = key
      end

      #
      # Checks if the key for this entity exists in redis
      #
      #
      # @return [true] when exists
      # @return [false] when not exists
      #
      def exist?
        redis do |conn|
          value = conn.exists(key)
          return true if value.is_a?(TrueClass)
          return false if value.is_a?(FalseClass)

          value.positive?
        end
      end

      #
      # The number of microseconds until the key expires
      #
      #
      # @return [Integer] expiration in milliseconds
      #
      def pttl
        redis { |conn| conn.pttl(key) }
      end

      #
      # The number of seconds until the key expires
      #
      #
      # @return [Integer] expiration in seconds
      #
      def ttl
        redis { |conn| conn.ttl(key) }
      end

      #
      # Check if the entity has expiration
      #
      #
      # @return [true] when entity is set to exire
      # @return [false] when entity isn't expiring
      #
      def expires?
        pttl.positive? || ttl.positive?
      end

      #
      # Returns the number of entries in this entity
      #
      #
      # @return [Integer] 0
      #
      def count
        0
      end
    end
  end
end
