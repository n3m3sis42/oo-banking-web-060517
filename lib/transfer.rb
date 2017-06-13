class Transfer
  attr_reader :sender, :receiver, :status, :amount

  def initialize(sender, receiver, amount)
      @sender = sender
      @receiver = receiver
      @amount = amount
      @status = "pending"
  end

  def valid?
    @sender.valid? && @receiver.valid?
  end

  def execute_transaction
    case
    when !self.valid?
      reject_transaction("Invalid sending or receiving bank account. Transfer rejected.")
    when @sender.balance < @amount
      reject_transaction("Transaction rejected. Please check your account balance.")
    when @status == "complete"
      "Transaction already complete. Please initiate a new transfer to move more money."
    else
      process_transaction
    end
  end

  def reject_transaction(error_msg)
    @status = "rejected"
    error_msg
  end

  def process_transaction
    @sender.balance -= @amount
    @receiver.balance += @amount
    @status = "complete"
  end

  def reverse_transfer
    return if status != "complete"
    @sender.balance += @amount
    @receiver.balance -= @amount
    @status = "reversed"
  end

end
