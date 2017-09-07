module PipedriveHelpers
  refine Object do
    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end

    def present?
      !blank?
    end
  end
end
